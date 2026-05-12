import os
import sys
import shutil
import platform
from pathlib import Path

# 配置信息
system_config_folder_dict = {
    # neovim
    ('windows', 'neovim'): Path.home() / 'AppData' / 'Local' / 'nvim',
    ('linux', 'neovim'): Path.home() / '.config' / 'nvim',
    # PowerShell
    ('windows', 'powershell'): Path.home() / 'Documents' / 'PowerShell',
}

current_folder_dict = {
    # neovim
    ('windows', 'neovim'): Path('./nvim').resolve(),
    ('linux', 'neovim'): Path('./nvim').resolve(),
    # PowerShell
    ('windows', 'powershell'): Path('./PowerShell').resolve(),
}

def create_link(src, dst):
    # 创建软链接
    if dst.exists() or dst.is_symlink():
        print(f'Warning: Target path {dst} already exists!')
        print("Please manually delete or backup the folder before running the link command.")
        return

    # 确保父目录存在
    dst.parent.mkdir(parents=True, exist_ok=True)

    try:
        os.symlink(src, dst, target_is_directory=True)
        print(f'Successfully linked {dst} to {src}')
    except OSError as e:
        print(f'Error: Failed to create symlink. {e}')

def remove_link(src, dst):
    # 取消软链接并保留内容
    if not dst.is_symlink():
        print(f"Directory {dst} is not a symlink. No action taken.")
        return

    print(f"Unlinking {dst} and keeping content...")

    
    # 将内容从仓库临时复制出来（因为直接删链接可能导致路径失效）
    temp_dir = dst.parent / (dst.name + "_backup_tmp")
    shutil.copytree(src, temp_dir)

    # 删除软链接
    if platform.system() == "Windows" and dst.is_dir():
        os.rmdir(dst) # Windows 删除目录链接常用 rmdir
    else:
        os.remove(dst)

    # 将内容移回原位
    shutil.move(temp_dir, dst)
    print(f"Successfully unlinked {dst} and kept content.")

def main():
    if len(sys.argv) != 4:
        print('Usage: python manage.py <os_name> <config_name> <operate>')
        print('Example: python manage.py windows neovim link')
        sys.exit(1)

    os_arg = sys.argv[1].lower()
    config_arg = sys.argv[2].lower()
    operate = sys.argv[3].lower()

    key = (os_arg, config_arg)

    if key not in system_config_folder_dict or key not in current_folder_dict:
        print(f"Unsupported configuration combination: {os_arg} - {config_arg}")
        sys.exit(1)

    sys_path = system_config_folder_dict[key]
    repo_path = current_folder_dict[key]

    if operate == 'link':
        create_link(repo_path, sys_path)
    elif operate == 'unlink':
        remove_link(repo_path, sys_path)
    else:
        print(f"Unsupported operation: {operate}")

if __name__ == "__main__":
    main()