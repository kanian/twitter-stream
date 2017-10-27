FROM microsoft/dotnet
WORKDIR /app

LABEL Author = "Patrick Assoa Adou"
LABEL Email = "kanian77@gmail.com"
 

COPY *.csproj ./

RUN  dotnet restore
# Copy everything else and build
COPY . ./ 

RUN dotnet publish -c Release -o out

EXPOSE 8080

ENTRYPOINT ["dotnet", "out/twitter-streamer.dll"]

# Application will be in app folder

# ADD deploy.sh /
# CMD ["/bin/bash", "/deploy.sh"]
