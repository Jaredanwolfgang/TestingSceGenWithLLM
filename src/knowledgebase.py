import os
from typing import Optional

from chromadb.config import Settings
from langchain.vectorstores import Chroma
from langchain.document_loaders import JSONLoader
from langchain.embeddings import LlamaCppEmbeddings
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter

CHROMA_DB_DIRECTORY='db'
DOCUMENT_SOURCE_DIRECTORY='../document'
CHROMA_SETTINGS = Settings(
    chroma_db_impl='duckdb+parquet',
    persist_directory=CHROMA_DB_DIRECTORY,
    anonymized_telemetry=False
)
TARGET_SOURCE_CHUNKS=4
CHUNK_SIZE=500
CHUNK_OVERLAP=50
HIDE_SOURCE_DOCUMENTS=False

class MyKnowledgeBase:
    def __init__(self, source_path: str) -> None:
        """
        Loads pdf and creates a Knowledge base using the Chroma
        vector DB.
        Args:
            pdf_source_folder_path (str): The source folder containing 
            all the pdf documents
        """
        self.source_path = source_path
        self.vector_db = None

    def metadata_func(record: dict, metadata: dict) -> dict:
        metadata["title"] = record.get("title")
        return metadata

    def load_json(self):
        loader = JSONLoader(
            file_path=self.source_path,
            jq_schema=".data[]",
            content_key="html",
            metadata_func=self.metadata_func,
        )
        loaded_json = loader.load()
        return loaded_json

    def split_documents(
        self,
        loaded_docs,
    ):
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=CHUNK_SIZE,
            chunk_overlap=CHUNK_OVERLAP,
        )
        chunked_docs = splitter.split_documents(loaded_docs)
        return chunked_docs

    def convert_document_to_embeddings(
        self, chunked_docs, embedder
    ):
        vector_db = Chroma(
            persist_directory=CHROMA_DB_DIRECTORY,
            embedding_function=embedder,
            client_settings=CHROMA_SETTINGS,
        )

        vector_db.add_documents(chunked_docs)
        vector_db.persist()
        return vector_db

    def return_retriever_from_persistant_vector_db(
        self, embedder
    ):
        if not os.path.isdir(CHROMA_DB_DIRECTORY):
            raise NotADirectoryError(
                "Please load your vector database first."
            )
        
        vector_db = Chroma(
            persist_directory=CHROMA_DB_DIRECTORY,
            embedding_function=embedder,
            client_settings=CHROMA_SETTINGS,
        )

        return vector_db.as_retriever(
            search_kwargs={"k": TARGET_SOURCE_CHUNKS}
        )

    def add_text(self, example):
        pass

    def initiate_document_injetion_pipeline(self):
        loaded_json = self.load_json()
        chunked_documents = self.split_documents(loaded_docs=loaded_json)
        
        print("=> JSON loading and chunking done.")

        embeddings = LlamaCppEmbeddings(
            model_path="/home/loring/Documents/Llama-2-7B-Chat-GGUF/llama-2-7b-chat.Q4_K_M.gguf",
            n_gpu_layers=-1
        )

        self.vector_db = self.convert_document_to_embeddings(
            chunked_docs=chunked_documents, embedder=embeddings
        )

        print("=> vector db initialised and created.")
        print("All done")