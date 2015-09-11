;;;; icacls.lisp

(in-package #:icacls)

;;; "icacls" goes here. Hacks and glory await!


(defparameter *user-lst*
  '("anfyod" "avgris" "avpete" "aysnig" "dvryab" "eabuda" "epiven"
    "evbush" "evkoro" "gabank" "iesido" "iptroy" "mvivan" "nabuda"
    "namatv" "opgolo" "svdavl" "tdrach" "vgvant" "vvvilk" "yvshub"))

(defparameter *comp-lst*
  '("n118957"
    "n118944"
    "n133619"
    "ko11-118383"
    "n118965"
    "ko11-133148"
    "ko11-118667"
    "n118389"
    "ugko11-132866"
    "ko11-133037"
    "n118955"
    "n118940"
    "ko11-118665"))

(defun mkdir-home(comp home &optional (user-lst *user-lst*) (out (make-string-output-stream)))
  "Пример использования
(mkdir-home \"n118965\" \"home1\")
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
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A~%" comp home uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(RX,W)~%" comp home uname uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%" comp home uname uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A /inheritance:e~%" comp home uname)
       (format out "mkdir  \\\\~A\\d$\\~A\\_~A\\_private~%" comp home uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /inheritance:d~%" comp home uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove ZORYA\\~A~%" comp home uname uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /remove \"ZORYA\\Отдел 11 - все\"~%" comp home uname uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(RX,W)~%" comp home uname uname)
       (format out "icacls \\\\~A\\d$\\~A\\_~A\\_private /grant:r ZORYA\\~A:(OI)(CI)(IO)(M)~%" comp home uname uname))
   *user-lst*)
  (get-output-stream-string out))

;;;;(format t (mkdir-home "ko11-118383" "home1"))


(defun mkdir-home-all-comps(home &optional (user-lst *user-lst*) (comp-list *comp-lst*) (out (make-string-output-stream)))
  "Пример использования:
(mkdir-home-all-comps \"home1\")"
  (mapc #'(lambda(comp) (format out (mkdir-home comp home user-lst))) comp-list)
  (get-output-stream-string out))


;;;;(format t (mkdir-home-all-comps "home1"))


