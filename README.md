# Share Folder Read Only

## 🔹 توضیحات

این پروژه شامل یک **اسکریپت پاورشل** به نام `ShareReadOnly.ps1` است که به صورت خودکار یک پوشه به نام **SHARE** را روی درایو D ایجاد کرده و آن را به اشتراک می‌گذارد.  
ویژگی اصلی این اسکریپت این است که **Everyone فقط دسترسی خواندن (Read)** دارد و Administrators دسترسی کامل (Full) خواهند داشت.  

این اسکریپت مناسب محیط‌های مدرسه، اداره یا شبکه‌های کوچک است که می‌خواهند یک پوشه عمومی امن ایجاد کنند.

---

## 🔹 پیش‌نیازها

- ویندوز ۱۰ یا ۱۱ (Pro یا Enterprise توصیه می‌شود)  
- اجرای PowerShell با **Run as Administrator**  
- سرویس SMB فعال باشد (`LanmanServer`)  

---

## 🔹 کارهایی که این اسکریپت انجام می‌دهد

1. بررسی وجود پوشه `D:\SHARE` و ایجاد آن در صورت نبود  
2. حذف اشتراک قدیمی با نام SHARE در صورت وجود  
3. ایجاد **Advanced Share** برای Everyone با دسترسی فقط خواندن (Read)  
4. تنظیم **NTFS Permissions**: Everyone → فقط Read  
5. Administrators دسترسی کامل دارند  
6. نمایش پیام‌های فینگلیش در PowerShell برای اطلاع‌رسانی  

---

## 🔹 نحوه اجرا

1. دانلود یا کلون مخزن GitHub:  
```bash
git clone https://github.com/<username>/ShareFolderReadOnly.git
