rmdir build /s /Q

mkdir build
cd build

mkdir server
mkdir server\ebin
mkdir server\include
mkdir server\priv

mkdir generators
mkdir generators\ebin
mkdir generators\include

cd ..
cd server
call build.bat

cd ../generators
call build.bat

cd..
copy server\ebin build\server\ebin
copy server\include\settings.ini build\server\include

copy server\priv\test.yaws build\server\priv
copy server\priv\test.conf build\server
copy server\priv\run.bat build\server
mkdir build\server\logs

copy generators\ebin build\generators\ebin
copy generators\include\settings.ini build\generators\include
copy generators\priv\run.bat build\generators

rmdir server\ebin /s /Q
rmdir generators\ebin /s /Q


