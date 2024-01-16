# MemGPT

This Docker environment provides us with MemGPT and a persistent Postgres database.

## Preparation

1. Install Docker Desktop (version 18.0 or higher)

## Initialization

1. Create the .env file and set the values: `cp .env.dist .env` 
2. Run the start script: `./start.sh setup`

## Usage

**Start**

To start the MemGPT app, use `./start.sh`

The `[Docker]` environment starts, where you can start the `memgpt` app.

See next section for a list of common MemGPT commands.

**Stop**

```shell
# Inside the [Docker] environment:
exit

# In your host terminal:
docker compose down
```

## MemGPT commands

```shell
# Set default config for MemGPT
memgpt configure

# Start MemGPT using the defined defaults
memgpt run

# List resources 
memgpt list [agents|humans|personas|sources]
```

**Using Archival Memory**

```shell
# Step 1: Load data into the archival memory

memgpt load directory --name <dataset-name> --input-files <file-paths>
memgpt load directory --name <dataset-name> --input-dir <dir-path> --recursive true

memgpt load webpage --name <dataset-name> --urls <url-list>

memgpt load database --name <dataset-name> --query "SQL QUERY" --scheme <scheme> --host <host> --port <port> --dbname <database> --user <user> --password <password>


# List sources:

memgpt list sources


# Step 2: Attach archival memory to an agent

# A) Via the CLI before starting the chat:
memgpt attach --agent <agent-name> --data-source <dataset-name>

# B) Using a slash command during chat:
/attach
```

## Debugging

### MemGPT data

Most config details (like archival memory sources, humans, personas) are available in the folder `./config`

When you make changes to this folder, they are reflected to the Docker environment in real time. However, you need to restart (`memgpt run`) for the changes to take effect.

### Database Access

**Connection Details**

Connect to the DB using the `POSTGRES_*` details you set in `.env`:

| Setting  | Value                | Source    | Default    |
|----------|----------------------|-----------|------------|
| Host     | **localhost**        | hardcoded |            |
| User     | `POSTGRES_USER`      | .env      | "user"     |
| Password | `POSTGRES_PASSWORD`  | .env      | "password" |
| Port     | `POSTGRES_HOST_PORT` | .env      | 5432       |

**pgAdmin**

I recommend connecting to the Postgres DB using the [pgAdmin client](https://www.pgadmin.org/).

1. "Add New Server" (or main menu "Object > Create > Server")
2. Server details, when using the default `.env` config:
   - (General) Name: `Docker: MemGPT`
   - (Connection) Host name: `localhost`
   - (Connection) Port: `5432` (`POSTGRES_HOST_PORT` from `.env`)
   - (Connection) Username: `user` (`POSTGRES_USER` from `.env`)
   - (Connection) Password: `password` (`POSTGRES_PASSWORD` from `.env`)
   - (Connection) Save password? `Yes`

----

# Further notes

## LLM Model

**Recommended**

Start with the free Mixtral model:

* LLM Provider: `local` (confusing, I know)
* LLM backend: `vllm`
* Default endpoint: `https://api.memgpt.ai` (yes, this is _not_ local after all)
* Default model: `ehartford/dolphin-2.5-mixtral-8x7b`
* Model wrapper: `chatml`
* Model context window: `32768`

**GPT 4**

GPT4 is more powerful (but also more expensive). To use GPT4, go with the following settings:

1. First, enter your OpenAI API key in `.env`
2. Configure MemGPT with the following details

* LLM Provider: `openai`
* Default endpoint: `https://api.openai.com/v1`
* Default model: `gpt-4`|`gpt-4-32k`|`gpt-4-vision-preview`
* Model context window: `32768`

**Other models**

Using the `lcoal` provider, you can define any LLM model that supports **function calls**.

It's perfectly fine to switch between different LLM models even after starting your first chats. Choosing a different model affects the future conversation, regardless on which LLM was used to start the conversation.

Note: Once you create a new agent (start a new conversation), all config details are copied to that agent; changing the default config has no impact on that existing agent. However, you can manually edit the agent details, by editing the relevant details in `./config/agents`

## Embedding model choice

Embedding plays a role in indexing archival memory.

Choosing the right embedding model depends on the content that should be included in the archival memory.

> **Attention**: Changing the embedding model after creating your first embeddings will invalidate existing embeddings, and possibly also break the DB structure.
> If you want to switch to a different embedding model, the best solution is to start over with a fresh DB and recreate all embeddings.

**Text Only**

When the archival memory contains text documents (e.g. contracts, correspondence, manuals, blog articles) then the choice is between

* Hugging-Face `BAAI/bge-large-en-v1.5`
* OpenAI `text-embedding-ada-002`

**Text And Code**

When also code files should be embedded, in addition to text documents, then the choice is clear: 

* OpenAI `text-embedding-ada-002` - this model has a more balanced understanding of diverse content (like NLP and Code) compared to the NLP only models by Hugging Face

**OpenAI Model**

When using the OpenAI model, remember to enter your API key in `.env`
