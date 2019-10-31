;;;; icacls.lisp

(in-package #:cl-user)

(defpackage #:icacls
  (:use #:cl)
  (:export mkdir-home-all-comps mkdir-home))

;;;;(declaim (optimize (speed 0) (sayfety 3) (debug 3)))

(in-package #:icacls)

;;; "icacls" goes here. Hacks and glory await!

(defparameter *user-lst*
  '(("anfyod" "Федоров А.Н."      )
    ("avgris" "Гришина А.В."      )
    ("avpete" "Петельчиц А.В."    )
    ("aysnig" "Снигирь А.Ю."      )
    ("dvryab" "Рябов Д.В."        )
    ("epiven" "Пивень Е.Н."       )
    ("evkoro" "Коротич Е.В."      )
    ("gabank" "Банкулова Г.А."    )
    ("iptroy" "Тройнич И.П."      )
    ("mvivan" "Иванов М.В."       )
    ("namatv" "Матвеев Н.А."      )
    ("opgolo" "Головерда О.П."    )
    ("svdavl" "Давлеткужин С.В."  )
    ("tdrach" "Зинченко Т.Ю."     )
    ("vgvant" "Ванцовский В.Г."   )))

(defparameter *user-lst-depricated*
  '(("eabuda" "Буданова Е.А." )
    ("evbush" "Симонова Е.В." )
    ("iesido" "Сидоров И.Е."  )
    ("nabuda" "Буданова Н.А." )
    ("vvvilk" "Вилкул В.В."   )
    ("yvshub" "Шубельняк Ю.В.")))

(defparameter *comp-lst*
  '(("ko11-118667" "tdrach")
    ("n118955"     "mvivan")
    ("n118389"     "iptroy")
    ("n000171"     "avpete")
    ("n118944"     "aysnig")
    ("ko11-133148" "anfyod")
    
    ("ko11-118665" "vgvant")
    ("n118940"     "svdavl")
    ("n118965"     "opgolo")
    ("n132866"     "dvryab")
    ("ko11-133037" "avgris")
    ("n118957"     "gabank")
    ("n133619"     "epiven")
    ("ko11-118383" "namatv")))

(defun mkdir-home(comp home &key (user-lst *user-lst*) (out (make-string-output-stream)))
  "Пример использования
;;;; (mkdir-home \"n118965\" \"home1\")
"
  (format out "icacls \\\\~A\\d$ /grant:r \"NT AUTHORITY\\система\":(OI)(CI)(F)~%" comp)
  (format out "icacls \\\\~A\\d$ /grant:r \"BUILTIN\\Администраторы\":(OI)(CI)(F)~%" comp)
  (format out "icacls \\\\~A\\d$ /grant:r \"ZORYA\\Отдел 11 - все\":(OI)(CI)(RX)~%" comp)
  (format out "mkdir  \\\\~A\\d$\\~A~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"NT AUTHORITY\\система\":(OI)(CI)(F)~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"BUILTIN\\Администраторы\":(OI)(CI)(F)~%" comp home)
  (format out "icacls \\\\~A\\d$\\~A /grant:r \"ZORYA\\Отдел 11 - все\":(OI)(CI)(RX)~%" comp home)
  (mapc
   #'(lambda (uname)
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A~%" comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(RX,W)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A /inheritance:e~%"
	       comp home (first uname))
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A\\_private~%"
	       comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /inheritance:d~%"
	       comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove ZORYA\\~A~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove \"ZORYA\\Отдел 11 - все\"~%"
	       comp home (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(RX,W)~%"
	       comp home (first uname) (first uname))
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%"
	       comp home (first uname) (first uname)))
   user-lst)
  (get-output-stream-string out))

;;;;(format t (mkdir-home "ko11-118383" "home1"))


(defun mkdir-home-all-comps(home &key (user-lst *user-lst*) (comp-list *comp-lst*) (out (make-string-output-stream)))
  "Пример использования:
;;;; (mkdir-home-all-comps \"home1\")"
  (mapc
   #'(lambda (comp)
       (format out (mkdir-home (first comp) home  :user-lst user-lst)))
   comp-list)
  (get-output-stream-string out))


;;;;(format t (mkdir-home-all-comps "home1"))



