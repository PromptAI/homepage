<p align="center">
  <img src="./images/main.png" alt="PromptDialog 2.0" style="max-width: 100%;">
</p>

<p align="center">
  📌 <a href="https://www.promptai.us">Introducing PromptDialog 2.0: Agent-based Architecture for Conversational AI</a>
</p>

<p align="center">
  <a href="https://www.promptai.us">Cloud Service</a> ·
  <a href="#localized-deployment">Self-hosting</a> ·
  <a href="https://doc.promptai.us">Documentation</a> ·
  <a href="mailto:info@promptai.us">Enterprise inquiry</a>
</p>

PromptDialog is a platform for building conversational AI applications. The new 2.0 version leverages agent-based architecture to simplify bot development, making it more intuitive and powerful for both developers and business users.

## What's New in PromptDialog 2.0

We are excited to introduce a major upgrade: PromptDialog 2.0. The new version transitioned from [Rasa](https://github.com/RasaHQ/rasa) to [MICA](https://mica-labs.github.io/), as we believe that agent-based architecture represents the future of bot development. In PromptDialog 2.0, everything revolves around agents—eliminating the need for separate NLU, state management, and response generation. The new approach not only simplifies development but also makes advanced downstream tasks possible such as automated testing and evaluation.

MICA is an open-source, agent-centric framework that sets itself apart from existing solutions such as [AutoGen](https://github.com/microsoft/autogen), [CrewAI](https://github.com/crewAIInc/crewAI), [LangChain](https://github.com/langchain-ai/langchain), [Amazon MAO](https://github.com/awslabs/multi-agent-orchestrator), and [Swarm](https://github.com/openai/swarm), which rely heavily on extensive Python programming. With MICA, users can define [agents](https://mica-labs.github.io/docs/concepts/agent/) within a single YAML file before launching the bot, significantly simplifying development and deployment.

## Key Features

**1. Agent-based Architecture**:
Define conversational agents in simple YAML files, eliminating the need for complex Python programming.

**2. Intuitive Business Logic Design**:
Dialog flows can be described in text or drawn explicitly, making them easier to understand and share with team members.

**3. All-in-one DevOps**:
Design, develop, and operate conversations on premises or in the cloud, all from a single platform.

**4. Zero-shot Capabilities**:
Intent classification and entity recognition with no annotation required.

**5. Design Studio & Cloud Deployment**:
Build customer service bots more simply and cost-effectively with our visual design tools.

## Example: MICA Agent Definition

<details>
  <summary>Money Transfer Agent Example</summary>

```yaml
transfer_money:
  type: llm agent
  description: This is an agent for transfer money request.
  prompt: "You are a smart agent for handling transferring money request. When user ask for transferring money, it is necessary to sequentially collect the recipient's information and the transfer amount. Then, the function \"validate_account_funds\" should be called to check whether the account balance is sufficient to cover the transfer. If the balance is insufficient, it should return to the step of requesting the transfer amount. Finally, before proceeding with the transfer, confirm with the user whether the transfer should be made and then call \"submit_transaction\"."
  args:
    - recipient
    - amount_of_money
  uses:
    - validate_account_funds
    - submit_transaction

meta:
  type: ensemble agent
  description: You can select an agent to response user's question.
  contain:
    - transfer_money
  fallback: default
  steps:
    - call: transfer_money
  exit:
    - policy: "After 5 seconds, give a closure prompt: Is there anything else I can help you with?  After another 30 seconds, then leave."

main:
  steps:
    - call: meta
```
</details>

A complete example is available at [MICA GitHub Repository](https://github.com/Mica-labs/MICA/tree/main/examples/transfer_money).

## Quick Start

### Cloud Service
The easiest way to get started with PromptDialog 2.0 is through our cloud service:
- Visit [www.promptai.us](https://www.promptai.us) to create an account and start building your first agent.

### Localized Deployment

> Before installing PromptDialog, make sure your machine meets the following minimum system requirements:
>
> - OS: Linux / MacOS
> - Location: $HOME/zbot
> - RAM: At least 8GB
> - Docker: 20.10.6 or newer
> - Disk Space: At least 32GB available

Run the following command in your terminal:

```bash
curl -o install.sh 'https://cdn.githubraw.com/PromptAI/homepage/main/scripts/install_en.sh' && chmod +x install.sh && ./install.sh
```

After running, you can access the PromptDialog app in your browser at [http://localhost:9000](http://localhost:9000).

## Community & Contact

If you have any questions, suggestions, or partnership inquiries, feel free to contact us through the following channels:
- Submit an [Issue or PR](https://github.com/PromptAI/promptdialog) on our GitHub Repo
- Send an email to [info@promptai.us](mailto:info@promptai.us)
- Visit our [Contact Page](https://www.promptai.us/en/contact/)

## Security

To protect your privacy, please avoid posting security issues on GitHub. Instead, send your questions to [info@promptai.us](mailto:info@promptai.us) and we will provide you with a more detailed answer.

## License

Free use