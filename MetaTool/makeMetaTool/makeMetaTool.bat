rem *** set j2se path ***//JAVA_HOME=J2SDK Install Directory
set JAVA_HOME=C:\j2sdk1.4.2_03
rem *********************

set PATH=%JAVA_HOME%\bin;%PATH%
set CLASSPATH=.;%CLASSPATH%

del *.class
del *.oo
del MetaTool.jar
copy ..\*.class
copy ..\*.oo
jar cvfm MetaTool.jar MetaTool.mf *.class javax org images
del *.class
