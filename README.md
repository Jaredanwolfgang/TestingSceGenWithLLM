# SceGenwithLLM

This is the repository for the project Scenario Generation with Large Language Models based on the paper [Dialogue-based generation of self-driving simulation scenarios using Large Language Models](https://arxiv.org/abs/2310.17372).

# Instructions

* Install Scenic from the repository
* Install numpy openai backoff tiktoken langchain from pip 
* Run scenario_generation/notebook_generate_multistep_with_sim_eval.ipynb

# Our Workflow

The whole projects seem hard to finish within one semester, the goal of the project is limited
to finish phase 1 and phase 2. Based on this goal, our further plans are:

Phase 1:
* Carla-Challenge Scenarios and NHTSA Crash Data Systems Parsing
* Scenic Grammar study and review
* Connect Scenic format data with CARLA
* RAG structure design

Phase 2:
* Semantic Validation Testing methods

The package that we uses to tune the Large Language Models is LangChain, using which we try to construct a output parser and also a chained agents. 

# License

BSD 3-Clause (see LICENSE).
Note: this repository contains data created from processing the examples in the [Scenic repository](https://github.com/BerkeleyLearnVerify/Scenic), the Scenic autors retain all the rights to this data.
The data augmentations in scenario_generation/curated_50_50_split_augmented/ have been created with the OpenAI GPT-3 model (text-davinci-003) and they are therefore subject to the [OpenAI Terms and policies](https://openai.com/policies). These augmentations are not necessary to run the experiments.
