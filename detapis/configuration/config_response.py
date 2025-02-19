from fastapi import HTTPException
from fastapi.exceptions import RequestValidationError, ResponseValidationError
from fastapi.responses import JSONResponse
from fastapi.requests import Request
from loguru import logger
from pydantic import BaseModel


class SuccessResponse(BaseModel):
    message: str = "Success"

    def __init__(self):
        super().__init__(message=self.message)

    class Config:
        extra = "forbid"


class CustomException(Exception):
    def __init__(self, status_code: int, detail: str):
        self.status_code = status_code
        self.detail = detail


async def custom_exception_handler(request: Request, exc: CustomException):
    logger.error(f"CustomException caught: {exc.status_code} - {exc.detail}")
    return JSONResponse(status_code=exc.status_code,
                        content={"error": exc.detail})


async def response_exception_handler(request: Request, exc: Exception):
    logger.error(exc)
    return JSONResponse(status_code=500,
                        content={"error": "Response Error"})


async def http_exception_handler(request: Request, exc: HTTPException):
    logger.error(exc)
    if exc.status_code == 400:
        return JSONResponse(status_code=400,
                            content={"error": "Bad Request"})
    elif exc.status_code == 401:
        return JSONResponse(status_code=401,
                            content={"error": "Unauthorized"})
    elif exc.status_code == 403:
        return JSONResponse(status_code=403,
                            content={"error": "Forbidden"})
    elif exc.status_code == 404:
        return JSONResponse(status_code=404,
                            content={"error": str(exc)})
    elif exc.status_code == 500:
        # if exc.detail:
        #     return JSONResponse(status_code=500,
        #                         content={"error": f"Internal Server Error: {str(exc.detail)}"})
        return JSONResponse(status_code=500,
                            content={"error": f"Internal Server Error"})
    else:
        return JSONResponse(status_code=exc.status_code,
                            content={"error": str(exc.detail)})


async def request_validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.error(f"RequestValidationError caught: {exc}")
    errors = exc.errors()
    if errors:
        # 첫 번째 오류 메시지를 사용
        error_msg = errors[0].get('msg', 'Invalid Input Data')
    else:
        error_msg = 'Invalid Input Data'

    return JSONResponse(
        status_code=422,
        content={"error": error_msg}
    )


exception_handlers = {
    CustomException: custom_exception_handler,
    404: http_exception_handler,
    HTTPException: http_exception_handler,
    RequestValidationError: request_validation_exception_handler,
    ResponseValidationError: response_exception_handler
}

exception_response = {
    "400": {
        "description": "에러 메세지",
        "content": {
            "application/json": {
                "schema": {
                    "type": "object",
                    "properties": {
                        "error": {
                            "type": "string",
                            "example": "Bad Request"
                        }
                    }
                }
            }
        }
    },
    "422": {
        "description": "유효성 에러 메세지",
        "content": {
            "application/json": {
                "schema": {
                    "type": "object",
                    "properties": {
                        "error": {
                            "type": "string",
                            "example": "Invalid Input Data"
                        }
                    }
                }
            }
        }
    }
}
