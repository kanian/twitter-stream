FROM microsoft/dotnet:1.0-sdk AS build-env
# WORKDIR /app

LABEL Author = "Patrick Assoa Adou"
LABEL Email = "kanian77@gmail.com"
 

COPY *.csproj ./

RUN  dotnet restore
# Copy everything else and build
COPY . ./ 

RUN dotnet publish -c Release -o out \
    && rm -rf /tmp/emitter

# build runtime image
FROM microsoft/dotnet:1.0-runtime
WORKDIR .
COPY --from=build-env /out ./
ENTRYPOINT ["dotnet", "twitter-streamer.dll"]

# Application will be in app folder
WORKDIR /out
ADD deploy.sh /
CMD ["/bin/bash", "/deploy.sh"]