1) Проект "icacls" предназначен для генерирования
настроечных сценариев командной строки оболочки cmd,
позволяющих сгенерировать папки пользователей и
настроить их атрибуты безопасности

2) В результате выполнения на должны быть установлены следующие разрешения

D:\>icacls d:
d: NT AUTHORITY\система:(OI)(CI)(F)
   BUILTIN\Администраторы:(OI)(CI)(F)
   ZORYA\Отдел 11 - все:(OI)(CI)(RX)

Успешно обработано 1 файлов; не удалось обработать 0 файлов

D:\>icacls d:/home
d:/home NT AUTHORITY\система:(I)(OI)(CI)(F)
        BUILTIN\Администраторы:(I)(OI)(CI)(F)
        ZORYA\Отдел 11 - все:(I)(OI)(CI)(RX)

Успешно обработано 1 файлов; не удалось обработать 0 файлов

D:\>icacls d:/home/_epiven
d:/home/_epiven ZORYA\epiven:(OI)(CI)(IO)(M)
                ZORYA\epiven:(RX,W)
                NT AUTHORITY\система:(I)(OI)(CI)(F)
                BUILTIN\Администраторы:(I)(OI)(CI)(F)
                ZORYA\Отдел 11 - все:(I)(OI)(CI)(RX)

Успешно обработано 1 файлов; не удалось обработать 0 файлов

D:\>icacls d:/home/_epiven/_private
d:/home/_epiven/_private BUILTIN\Администраторы:(OI)(CI)(F)
                         ZORYA\epiven:(OI)(CI)(IO)(M)
                         ZORYA\epiven:(RX,W)

Успешно обработано 1 файлов; не удалось обработать 0 файлов
