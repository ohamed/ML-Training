@echo off
set "source=C:\WPy64-312101\notebooks\ML-Training"
set "target=C:\Users\o.hamed\Documents\Dev\GitHub\ML-Training\ipynb"

echo Copying .ipynb files starting with "lecture" from "%source%" to "%target%" ...
xcopy "%source%\lecture6*.ipynb" "%target%" /I /H /K /Y

echo Done.
pause