# Use the latest official Python runtime as a parent image
FROM python:3.14-rc-slim

# Set the working directory in the container
WORKDIR /app

# Create a non-root user and group with limited privileges
RUN groupadd -r gitingest && useradd --no-log-init -r -g gitingest gitingest

# Copy the requirements file into the container at /app with appropriate ownership
COPY --chown=gitingest:gitingest cyclotruc-gitingest/requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container with appropriate ownership
COPY --chown=gitingest:gitingest cyclotruc-gitingest/ /app/

# Create a directory for temporary files with correct ownership
RUN mkdir -p /app/tmp && chown -R gitingest:gitingest /app/tmp

# Change to the non-root user
USER gitingest

# Expose the port
EXPOSE 42069

# Define environment variable for the port (can be overridden with docker-compose)
ENV PORT=42069

# Run uvicorn when the container launches
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "42069"]
