import os
import sys
import shutil
import platform
from pathlib import Path


system_config_path_dict = {
    # neovim
    ('windows', 'neovim'): Path.home() / 'AppData' / 'Local' / 'nvim',
    ('linux', 'neovim'): Path.home() / '.config' / 'nvim',
    # PowerShell
    ('windows', 'powershell'): Path.home() / 'Documents' / 'PowerShell',
    # wezterm
    ('windows', 'wezterm'): Path.home() / '.wezterm.lua',
    ('linux', 'wezterm'): Path.home() / '.wezterm.lua',
}

current_path_dict = {
    # neovim
    ('windows', 'neovim'): Path('./nvim').resolve(),
    ('linux', 'neovim'): Path('./nvim').resolve(),
    # PowerShell
    ('windows', 'powershell'): Path('./PowerShell').resolve(),
    # wezterm
    ('windows', 'wezterm'): Path('./Wezterm/wezterm.lua').resolve(),
    ('linux', 'wezterm'): Path('./Wezterm/wezterm.lua').resolve(),
}

def create_link(src, dst):
    # 检查源文件/文件夹是否存在
    if not src.exists():
        print(f"Error: Source path {src} does not exist in your repository!")
        return

    # 检查目标路径是否被占用
    if dst.exists() or dst.is_symlink():
        print(f'Warning: Target path {dst} already exists!')
        print("Please manually delete or backup the path before running the link command.")
        return

    # 确保父目录存在
    dst.parent.mkdir(parents=True, exist_ok=True)

    try:
        # 动态判断是文件还是文件夹
        is_directory = src.is_dir()
        os.symlink(src, dst, target_is_directory=is_directory)
        
        path_type = "directory" if is_directory else "file"
        print(f'Successfully linked {path_type} {dst} to {src}')
    except OSError as e:
        print(f'Error: Failed to create symlink. {e}')

def remove_link(src, dst):
    # 取消软链接并保留内容
    if not dst.is_symlink():
        print(f"Path {dst} is not a symlink. No action taken.")
        return

    print(f"Unlinking {dst} and keeping content...")

    is_directory = src.is_dir()
    temp_path = dst.parent / (dst.name + "_backup_tmp")

    try:
        # 将内容从仓库临时复制出来（根据文件或文件夹使用不同的复制方法）
        if is_directory:
            shutil.copytree(src, temp_path)
        else:
            shutil.copy2(src, temp_path)
            
        # 删除软链接
        if platform.system() == "Windows" and is_directory:
            os.rmdir(dst) # Windows 删除目录链接常用 rmdir
        else:
            os.remove(dst) # Linux 统统用 remove，Windows 的文件链接也用 remove

        # 将内容移回原位
        shutil.move(str(temp_path), str(dst))
        
        path_type = "directory" if is_directory else "file"
        print(f"Successfully unlinked {path_type} {dst} and kept content.")
        
    except Exception as e:
        print(f"Error during unlinking process: {e}")
        # 如果出错尝试清理临时文件
        if temp_path.exists():
            if is_directory:
                shutil.rmtree(temp_path)
            else:
                os.remove(temp_path)

def main():
    if len(sys.argv) != 4:
        print('Usage: python manage.py <os_name> <config_name> <operate>')
        print('Example: python manage.py windows neovim link')
        sys.exit(1)

    os_arg = sys.argv[1].lower()
    config_arg = sys.argv[2].lower()
    operate = sys.argv[3].lower()

    key = (os_arg, config_arg)

    if key not in system_config_path_dict or key not in current_path_dict:
        print(f"Unsupported configuration combination: {os_arg} - {config_arg}")
        sys.exit(1)

    sys_path = system_config_path_dict[key]
    repo_path = current_path_dict[key]

    if operate == 'link':
        create_link(repo_path, sys_path)
    elif operate == 'unlink':
        remove_link(repo_path, sys_path)
    else:
        print(f"Unsupported operation: {operate}")

if __name__ == "__main__":
    main()
