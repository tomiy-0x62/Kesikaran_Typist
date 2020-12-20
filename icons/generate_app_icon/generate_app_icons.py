import cv2
import numpy as np
import sys
import os
from PIL import Image

# 画像サイズは1024
# 画像はこのディレクトリに直に置くこと
# 生成するアイコンは./\(appname)_icons/\(appname)_\(size).png
imag_paht = "objectdetecter_v2.png"

def imread(filename, flags=cv2.IMREAD_COLOR, dtype=np.uint8):
    try:
        n = np.fromfile(filename, dtype)
        img = cv2.imdecode(n, flags)
        return img
    except Exception as e:
        print(e)

        print("imread error!")
        return None

def cv2pil(image_cv):
    # 画像をcv2形式(np.array)からPILL形式に変換
    image_cv = cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB)
    image_pil = Image.fromarray(image_cv)
    image_pil = image_pil.convert('RGB')

    return image_pil

img_name = imag_paht.rsplit(".", 1)  # '.'で画像名を分割
app_name = img_name[0]  # 画像名から拡張子を除いたものを取得
save_dir = "{}_icons".format(app_name)

image_cv2 = imread(imag_paht)
h, w, _ = image_cv2.shape
if not h == w:
    print("Error: Image '{}' is not square".format(imag_paht))
    sys.exit(1)

if not h == 1024:
    print("Error: Image '{}' is not 1024 x 1024".format(imag_paht))
    sys.exit(1)

# もし指定された画像から既にアイコンが生成されていたら終了
if os.path.isdir(save_dir):
    print("Error: {}'s icon is already generated.".format(app_name))
    sys.exit(1)
else:
    os.mkdir(save_dir)

array_size = [40, 60, 58, 87, 120, 180, 20, 29, 80, 76, 152, 167, 1024]

image = cv2pil(image_cv2)

for i in array_size:

    resized = image.resize((i, i), Image.ANTIALIAS)
    resized = np.asarray(resized)
    save_path = "./{}/{}_{}.png".format(save_dir, app_name, i)
    cv2.imwrite(save_path, resized[:, :, ::-1])
