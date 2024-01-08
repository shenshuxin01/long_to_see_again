import pyautogui
import time


# 获取屏幕尺寸
w, h = pyautogui.size()

print(w)
print(h)


def m(x,y,t):
    # 鼠标移动到屏幕中央
    pyautogui.moveTo(x, y,t)

    # 模拟鼠标单击事件
    #pyautogui.click()

    time.sleep(8)

while True:
    print("移动到【上】")
    m(w/2,h/3,3)
    print("移动到【右】")
    m(2*w/3,h/2,3)
    print("移动到【下】")
    m(w/2,2*h/3,3)
    print("移动到【左】")
    m(w/3,h/2,3)
    