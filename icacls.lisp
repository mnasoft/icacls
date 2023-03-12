;;;; icacls.lisp

(defpackage :icacls
  (:use #:cl)
  (:export  mkdir-home-all-comps-bat
	    help
	    mkdir-home
	    mkdir-home-bat))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :icacls)

;;; "icacls" goes here. Hacks and glory await!

(defparameter *user-lst*
  '(                            ("vgvant" "Ванцовский В.Г." )
    ("tdrach" "Зинченко Т.Ю." ) ("svdavl" "Давлеткужин С.В.")
    ("mvivan" "Иванов М.В."   ) ("opgolo" "Головерда О.П."  )
    (                            "dvryab" "Рябов Д.В."      )
    ("iptroy" "Тройнич И.П."  ) ("avgris" "Гришина А.В."    )
    ("avpete" "Петельчиц А.В.") ("gabank" "Банкулова Г.А."  )
    ("evkoro" "Коротич Е.В."  ) ("epiven" "Пивень Е.Н."     )
    ("anfyod" "Федоров А.Н."  ) ("namatv" "Матвеев Н.А."    ))
  "Список действующих пользователей отдела 11")

(defparameter *user-lst-depricated*
  '(("aysnig" "Снигирь А.Ю."  )
    ("eabuda" "Буданова Е.А." )
    ("evbush" "Симонова Е.В." )
    ("iesido" "Сидоров И.Е."  )
    ("nabuda" "Буданова Н.А." )
    ("vvvilk" "Вилкул В.В."   )
    ("yvshub" "Шубельняк Ю.В."))
  "Список недействующих пользователей отдела 11")

(defparameter *comp-lst*
  '(                     ("n133875" "vgvant")
    ("n118944" "tdrach") ("n118940" "svdavl")
    ("n118955" "mvivan") ("n118965" "opgolo")
    (                     "n132866" "dvryab")
    ("n118389" "iptroy") ("n133037" "avgris")
    ("n000171" "avpete") ("n118957" "gabank")
    ("n118665" "evkoro") ("n133619" "epiven")
    ("n133148" "anfyod") ("n118383" "namatv"))
  "Закрепление ПК за пользователями."
  )

(export 'mkdir-home )
(defun mkdir-home (comp home &key (user-lst *user-lst*) (out t))
"@b(Описание:) функция @b(mkdir-home) 

 @b(Пример использования:)
@begin[lang=lisp](code)
 (mkdir-home \"n118965\" \"home1\")
@end(code)
"
  (format out "icacls \\\\~A\\d$ /grant:r \"NT AUTHORITY\\SYSTEM\":(OI)(CI)(F)~%" comp)
  (format out "icacls \\\\~A\\d$ /grant:r \"BUILTIN\\Administrators\":(OI)(CI)(F)~%" comp)
  (format out "icacls \\\\~A\\d$ /grant:r \"ZORYA\\Отдел 11 - все\":(OI)(CI)(RX)~%" comp)
  (format out "~%")
  (format out "mkdir  \\\\~A\\d$\\~A~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"NT AUTHORITY\\SYSTEM\":(OI)(CI)(F)~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"BUILTIN\\Administrators\":(OI)(CI)(F)~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"ZORYA\\Отдел 11 - все\":(OI)(CI)(RX)~%" comp home)
  (format out "~%")
  (mapc
   #'(lambda (uname)
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A~%" comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(RX,W)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /inheritance:e~%"
	       comp home (first uname))
       (format out "~%")
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A\\_private~%"
	       comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /inheritance:d~%"
	       comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove ZORYA\\~A~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(RX,W)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove \"ZORYA\\Отдел 11 - все\"~%"
	       comp home (first uname))
       (format out "~%"))
   user-lst))

(export 'mkdir-home-bat )
(defun mkdir-home-bat (comp home &key (user-lst *user-lst*))
"@b(Описание:) функция @b(mkdir-home) 

 @b(Пример использования:)
@begin[lang=lisp](code)
  (mkdir-home \"n118965\" \"home1\")
@end(code)
"
  (let ((fname (concatenate 'string "~/" comp "-" home ".bat")))
    (with-open-file (out fname
			 :direction :output
			 :if-exists :supersede)
      (mkdir-home comp home :user-lst user-lst :out out))
    (format t "~A" fname)))


(export 'mkdir-home-all-comps-bat )
(defun mkdir-home-all-comps-bat (home &key (user-lst *user-lst*) (comp-list *comp-lst*))
"@b(Описание:) функция @b(mkdir-home-all-comps-bat)

 @b(Пример использования:)
@begin[lang=lisp](code)
 (mkdir-home-all-comps \"home1\")
@end(code)
"
  (let ((fname (concatenate 'string "~/" "all-computers" "-" home ".bat")))
    (with-open-file (out fname
			 :direction :output
			 :if-exists :supersede)
      (mapc #'(lambda (comp) (mkdir-home (first comp) home :user-lst user-lst :out out))
	    comp-list))
    (format t "~A" fname)))

(export 'help )
(defun help ()
  "@b(Описание:) функция @b(help) выводит краткую справку.
"
  (format t "
*Задача:* создать на ПК *n133037* каталог *home1* с папками пользователей.

- Выполните следующий код на Лисп:
#+BEGIN_SRC lisp
  (icacls:mkdir-home-bat \"n133037\" \"home1\")
#+END_SRC
- В редакторе /Emacs/ откройте файл ~~/n133037.bat;
- Запустите командный интерпретатор /cmd/ от имени /Администратора/;
- Скопируйте содержимое файла ~~/n133037.bat в командный интерпретатор /cmd/;
- Перенесите папки пользователей из старого места в новое, используя /Explorer/.
"))

(help)

