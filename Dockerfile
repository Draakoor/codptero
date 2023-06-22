FROM mcr.microsoft.com/dotnet/aspnet:6.0

MAINTAINER draakoor, <dominique.wellisch@t-online.de>
WORKDIR /home/container/Lib
ENTRYPOINT ["dotnet", "IW4MAdmin.dll"]
