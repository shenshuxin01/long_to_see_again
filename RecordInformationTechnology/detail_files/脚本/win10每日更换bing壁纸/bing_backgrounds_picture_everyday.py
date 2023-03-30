# !/usr/bin/python
# -*- coding: UTF-8 -*-

import requests, time
import os, sys

g_path = 'D:\\appdata\\bing_backgrounds\\'

# 把旧图片移动 或者 删除 或者什么都不做
def del_file():
    # 删除
    # os.system("del /Q D:\\appdata\\bing_backgrounds\\*")
    # 移动
    os.system("move D:\\appdata\\bing_backgrounds\\* C:\\Users\\shenshuxin\\Pictures\\ ")


def get_current_time(format_time: str) -> str:
    # 移除
    return time.strftime(format_time, time.localtime())


def set_bing_backgrounds():
    print('这是ssx python文件执行的,配合win10壁纸选择文件夹')
    r = requests.get("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN")
    print(r.status_code)
    suffix_url = (r.json()['images'][0]['url'])
    title = (r.json()['images'][0]['title'])
    final_url = 'https://cn.bing.com' + suffix_url
    print("获取图片url信息：" + final_url)
    cur_time = get_current_time('%Y%m%d%H%M%S') + "_"
    pic = requests.get(final_url)
    if pic.status_code != 200:
        exit(1)
    del_file()
    pic_context = pic.content
    # 将他拷贝到本地文件 w 写  b 二进制  wb代表写入二进制文本
    # 保存路径
    path = g_path + cur_time + title + '.jpg'
    with open(path, 'wb') as f:
        f.write(pic_context)
    print("下载图片完成：" + path)

# 查看后台运行的进程 tasklist /v | findstr bing_backgrounds_picture_everyday
if __name__ == '__main__':
    last_date = ''
    while True:
        cur_date = get_current_time('%Y%m%d')
        if last_date != cur_date:
        #if True:
            print("批处理替换每日bing壁纸开始执行：" + last_date)
            last_date = cur_date
            set_bing_backgrounds()
        time.sleep(100)
