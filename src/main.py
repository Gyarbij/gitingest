from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
import os
from dotenv import load_dotenv
from api_analytics.fastapi import Analytics
from starlette.middleware.trustedhost import TrustedHostMiddleware
from routers import download, dynamic, index

load_dotenv()

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.add_middleware(Analytics, api_key=os.getenv('API_ANALYTICS_KEY'))

# Load allowed hosts from environment variable
allowed_hosts_env = os.getenv("ALLOWED_HOSTS", "localhost")
allowed_hosts = [host.strip() for host in allowed_hosts_env.split(",")]
app.add_middleware(TrustedHostMiddleware, allowed_hosts=allowed_hosts)

templates = Jinja2Templates(directory="templates")

@app.get("/api", response_class=HTMLResponse)
async def api_docs(request: Request):
    return templates.TemplateResponse(
        "api.html", {"request": request}
    )

@app.get('/favicon.ico')
async def favicon():
    return FileResponse('static/favicon.ico')

app.include_router(index)
app.include_router(download)
app.include_router(dynamic)
