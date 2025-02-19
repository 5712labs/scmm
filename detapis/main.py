from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from starlette.middleware.cors import CORSMiddleware

from configuration.config import settings
from domain.mmdet.api.v1 import mmdet_router

app = FastAPI(root_path=settings.ROOT_PATH,
              title=settings.APP_NAME,
            #   version="0.8.0",
            #   exception_handlers=exception_handlers,
            #   dependencies=[Depends(get_api_key)]
              )

# 'image' 디렉토리를 정적 파일로 제공
app.mount("/images", StaticFiles(directory="images"), name="images")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["message-id"],
)

app.include_router(mmdet_router.v1_router, tags=["mmdet"])
