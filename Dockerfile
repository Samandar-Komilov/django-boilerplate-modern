# Stage 1: Builder with uv
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

WORKDIR /app

# Cache uv packages
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv sync --frozen --no-install-project --no-dev

# Copy rest of project
ADD . /app

# Finalize install
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev


# Stage 2: Production/Final image
FROM python:3.12-slim-bookworm

# Set workdir
WORKDIR /app

# Copy from builder
COPY --from=builder --chown=app:app /app /app

# Add venv to PATH
ENV PATH="/app/.venv/bin:$PATH"

# Set entrypoint default (Django dev server for local)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
