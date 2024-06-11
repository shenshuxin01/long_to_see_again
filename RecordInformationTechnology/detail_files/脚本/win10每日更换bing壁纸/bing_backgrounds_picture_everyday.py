# !/usr/bin/python
# -*- coding: UTF-8 -*-

import random
import shutil
import requests, time
import os,re
import logging

g_path = 'D:\\appdata\\bing_backgrounds\\'
pid_path = 'D:\\'
g_local_pic = "C:\\Users\\shenshuxin\\Pictures"
CHANGE_MODE_LOCALFILE = True

# 把旧图片移动 或者 删除 或者什么都不做
def del_file():
    # 删除
    # os.system("del /Q D:\\appdata\\bing_backgrounds\\*")
    # 移动
    os.system("move D:\\appdata\\bing_backgrounds\\* C:\\Users\\shenshuxin\\Pictures\\ ")


def get_current_time(format_time: str) -> str:
    # 移除
    return time.strftime(format_time, time.localtime())



def kill_early_pid():
    # 删除其他的相关进程
    for i in os.listdir(pid_path):
        # ssx.bingbackground.picture.pid19084.log
        searchObj = re.search( r'ssx\.bingbackground\.picture.pid(\d+)\.log', i, re.M|re.I)
        if searchObj:
            logging.info(i+ "杀死之前的进程："+ searchObj.group(1))
            pid = int(searchObj.group(1))
            #根据pid杀死进程
            process = 'taskkill /f /pid %s'%pid
            os.system(process)
            #删除文件
            os.remove(pid_path+searchObj.group(0))

def get_bing_net():
    logging.info('这是ssx python文件执行的,配合win10壁纸选择文件夹')
    r = requests.get("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN")
    while r.status_code!=200:
        r = requests.get("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN")
        time.sleep(100)
        logging.info("请求url出错！" + str(r.status_code))
    suffix_url = (r.json()['images'][0]['url'])
    title = (r.json()['images'][0]['title'])
    final_url = 'https://cn.bing.com' + suffix_url
    logging.info("获取图片url信息：" + final_url)
    cur_time = get_current_time('%Y%m%d') + "_"
    pic = requests.get(final_url)
    while pic.status_code != 200:
        pic = requests.get(final_url)
        time.sleep(100)
        logging.info("请求pic出错！" + str(pic.status_code))

    del_file()
    pic_context = pic.content
    # 将他拷贝到本地文件 w 写  b 二进制  wb代表写入二进制文本
    # 保存路径
    path = g_path + cur_time + title.replace('?','？').replace('/','-').replace('\\','-') + '.jpg'
    with open(path, 'wb') as f:
        f.write(pic_context)
    logging.info("下载图片完成：" + path)


def set_bing_backgrounds():
    global CHANGE_MODE_LOCALFILE
    if CHANGE_MODE_LOCALFILE:
        pic_list = os.listdir(g_local_pic)
        # 随机获取一张图片
        local_one_pic = g_local_pic + '\\' + random.choice(pic_list)
        del_file()
        shutil.move(local_one_pic,g_path)    # 移动文件（目录）
    else:
        get_bing_net()
    CHANGE_MODE_LOCALFILE = not(CHANGE_MODE_LOCALFILE)

# 查看后台运行的进程 tasklist /v | findstr bing_backgrounds_picture_everyday
if __name__ == '__main__':
    kill_early_pid()
    pid = os.getpid()
    logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s %(levelname)s %(message)s',
                    datefmt='%a %d %b %Y %H:%M:%S',
                    filename='d:\\ssx.bingbackground.picture.pid'+str(pid)+'.log',
                    filemode='w')
    logging.info('程序开始执行！')
    logging.info('程序开始执行！')
    logging.info('程序开始执行！')
    logging.info('程序s开始执行！')
    logging.info('py运行的pid信息：'+str(pid))
    
    while True:
        try:
            logging.info("批处理替换每日bing壁纸开始执行")
            set_bing_backgrounds()
            time.sleep(70)
        except Exception as e:
            logging.exception("执行失败，重新执行任务",e)