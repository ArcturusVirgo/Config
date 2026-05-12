import os
import sys
import shutil
from pathlib import Path

system_config_folder_dict = {
    ('windows', 'neovim'): Path.home() / 'AppData' / 'Local' / 'nvim',
    ('linux', 'neovim'): Path.home() / '.config' / 'nvim',
}
current_folder_dict = {
    'neovim': Path('./nvim'),
}
ignore_files_dict = {
    'neovim': ['nvim-pack-lock.json'],
}

if len(sys.argv) != 4:
    print('Usage: python manage.py <os_name> <config_name> <operate>')
    print('Example: python manage.py windows neovim load')
    sys.exit(1)

os_name = sys.argv[1]
config_name = sys.argv[2]
operate = sys.argv[3]
if (os_name, config_name) not in system_config_folder_dict:
    print('Unsupported OS')
    sys.exit(1)
system_config_folder = system_config_folder_dict[(os_name, config_name)]
if config_name not in current_folder_dict:
    print('Unsupported configuration')
    sys.exit(1)
current_folder = current_folder_dict[config_name]
ignore_list = ignore_files_dict.get(config_name, [])

if operate == 'load':
    if os.path.exists(system_config_folder):
        shutil.rmtree(system_config_folder)

    shutil.copytree(current_folder, system_config_folder, ignore=shutil.ignore_patterns(*ignore_list))

if operate == 'save':
    if os.path.exists(current_folder):
        shutil.rmtree(current_folder)

    shutil.copytree(system_config_folder, current_folder, ignore=shutil.ignore_patterns(*ignore_list))

