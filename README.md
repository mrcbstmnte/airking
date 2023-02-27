# Airking-API

## Prerequisites

In order to successfully set up the API, you need to have docker installed on your local machine.

Ensure that you have the `.env` file at the root of the project. Please refer to the `.env.example` file for the necessary environment variable that the API depends on.

Within your `.env` file, set `DB_HOST`, `DB_NAME`, `DB_PASSWORD` and `DB_USERNAME` to the credentials of the database you have set up on your machine.

## Setup

The Docker application requires the configured `.env` file.

Add the following variable to the `.env` file:

```properties
DOCKERFILE=Dockerfile
```

The following variables are also used by Docker, and should already be included in the prerequisite `.env` file:

```properties
DB_NAME=<db name>
DB_USERNAME=<db username>
```

## Starting and running the application

On initial setup, this command should be ran in order for the database to be created

```bash
docker compose run airking_api rails db:create
```

To start the Docker application, simply execute the following command while in the project's root folder:

```bash
docker compose up --build -d
```

Afterwards the application should now be visible in the Docker dashboard or can be seen via the `docker ps` command.

## Testing

The API consists of multiple endpoints listed when `rails routes` is ran. Please see example usage in this [Postman Collection](https://www.postman.com/mrcbsmnte-1/workspace/hometime/collection/7576869-11e42005-12d5-4632-8438-b3e204f1c0e2?action=share&creator=7576869). Please do contact me at [mrcbstmnte@gmail.com](mailto:mrcbstmnte@gmail.com) if any issues are encountered.

Sample responses were also included in the postman endpoints collection for the possible success response and error scenarios.

## Endpoint considerations

```
4. Parse and save the payloads to a Reservation model that belongs to a Guest
 model. Reservation code and guest email field should be unique.
5. API should be able accept changes to the reservation. e.g., change in status,
check-in/out dates, number of guests, etc...
```

In order to achieve items #4 and 5, a single endpoint is created `POST /reservations` that accepts any of the two example payloads.

The creation and updating of reservation properties can be done using the same endpoint. To update the reservation, the same reservation code and guest details should be provided.

An error can be expected when the reservation was already saved and associated with the guest while another reservation(with the same reservation code) is about to be saved but with a different guest(email).

Endpoints to list all guests, guest reservations, and to list all reservations were also added. Please refer to [testing](#testing).
