#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["bogo.csproj", "."]
RUN dotnet restore "./bogo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "bogo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "bogo.csproj" -c Release -o /app/publish

FROM base AS final

# create user (appuser) with id (10001)
RUN useradd appuser -u 10001 --user-group

WORKDIR /app
COPY --chown=appuser --from=publish /app/publish .

RUN mkdir -p /app/App_Data
RUN chown -R appuser:appuser /app/App_Data
VOLUME ["/app/App_Data"]

USER 10001

ENV COMPlus_EnableDiagnostics=0
COPY --from=busybox:stable /bin/busybox /bin/busybox

ENTRYPOINT ["dotnet", "bogo.dll"]