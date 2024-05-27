# Use the official .NET image as a build stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
ENV PORT=80

# Use the SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ccse_cw1.csproj", "."]
RUN dotnet restore "./ccse_cw1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ccse_cw1.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "ccse_cw1.csproj" -c Release -o /app/publish

# Create the final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ccse_cw1.dll", "--urls=http://+:${PORT}"]
