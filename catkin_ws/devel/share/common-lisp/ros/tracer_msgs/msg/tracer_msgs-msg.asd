
(cl:in-package :asdf)

(defsystem "tracer_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "TracerBmsStatus" :depends-on ("_package_TracerBmsStatus"))
    (:file "_package_TracerBmsStatus" :depends-on ("_package"))
    (:file "TracerLightCmd" :depends-on ("_package_TracerLightCmd"))
    (:file "_package_TracerLightCmd" :depends-on ("_package"))
    (:file "TracerLightState" :depends-on ("_package_TracerLightState"))
    (:file "_package_TracerLightState" :depends-on ("_package"))
    (:file "TracerMotorState" :depends-on ("_package_TracerMotorState"))
    (:file "_package_TracerMotorState" :depends-on ("_package"))
    (:file "TracerRsStatus" :depends-on ("_package_TracerRsStatus"))
    (:file "_package_TracerRsStatus" :depends-on ("_package"))
    (:file "TracerStatus" :depends-on ("_package_TracerStatus"))
    (:file "_package_TracerStatus" :depends-on ("_package"))
    (:file "UartTracerMotorState" :depends-on ("_package_UartTracerMotorState"))
    (:file "_package_UartTracerMotorState" :depends-on ("_package"))
    (:file "UartTracerStatus" :depends-on ("_package_UartTracerStatus"))
    (:file "_package_UartTracerStatus" :depends-on ("_package"))
  ))