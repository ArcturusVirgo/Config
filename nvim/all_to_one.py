import os

# 遍历当前文件夹下的所有 .lua 文件
def find_lua_files(folder):
    lua_files = []
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith(".lua"):
                lua_files.append(os.path.join(root, file))
    return lua_files

def main():
    # 获取当前文件夹路径
    current_folder = os.path.dirname(os.path.abspath(__file__))
    
    # 查找所有 .lua 文件
    lua_files = find_lua_files(current_folder)
    
    f = open("nvim-config.txt", "w", encoding="utf-8")

    # 输出找到的 .lua 文件路径
    for lua_file in lua_files:
        if '.bak' in lua_file:
            continue
        f.write(lua_file + "\n")
        with open(lua_file, "r", encoding="utf-8") as file:
            content = file.read()
            f.write(content + "\n\n")
    f.close()

if __name__ == "__main__":
    main()