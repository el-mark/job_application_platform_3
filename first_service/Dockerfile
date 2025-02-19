# Use the official Ruby image with the required Ruby version.
FROM ruby:3.3.1

# Install required packages: build-essential, Node.js, and PostgreSQL client.
RUN apt-get update -qq && apt-get install -y build-essential nodejs libpq-dev

# Set the working directory in the container.
WORKDIR /rails

# Copy Gemfile and Gemfile.lock, then install gems.
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code.
COPY . .

# Expose the port (the docker-compose command ensures the correct port is used).
EXPOSE 3000

# The CMD is defined in docker-compose so this can be overridden.
CMD ["rails", "s", "-b", "0.0.0.0"]
