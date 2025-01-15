import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  dotenv.load();

  final apiKey = dotenv.env['GEMINI_API_KEY'];


  if (apiKey == null) {
    stderr.writeln(r'No $GEMINI_API_KEY environment variable');
    exit(1);
  }

  final model = GenerativeModel(
    model: 'gemini-2.0-flash-exp',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
  );

  final chat = model.startChat(history: [
    Content.multi([
      TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  [\n    {\n      budgetname:\n      category:\n      amount:\n    }\n  ]\n}'),
    ]),
    Content.model([
      TextPart('```json\n{\n  "monthlyBudget": [\n    {\n      "budgetname": "Housing",\n      "category": "Essential",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Food",\n       "category": "Variable",\n      "amount": 400\n    },\n     {\n      "budgetname": "Transportation",\n       "category": "Variable",\n      "amount": 300\n    },\n    {\n      "budgetname": "Entertainment",\n      "category": "Variable",\n      "amount": 100\n    },\n     {\n      "budgetname": "Savings",\n       "category":"Savings",\n      "amount": 833\n    },\n    {\n      "budgetname": "Others",\n      "category": "Variable",\n      "amount": 1167\n    }\n  ]\n}\n```\n'),
    ]),
    Content.multi([
      TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname:\n      category:\n      amount:\n    }\n  ]\n}'),
    ]),
    Content.model([
      TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Housing",\n      "category": "Essential",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Food",\n       "category": "Variable",\n      "amount": 400\n    },\n     {\n      "budgetname": "Transportation",\n       "category": "Variable",\n      "amount": 300\n    },\n    {\n      "budgetname": "Entertainment",\n      "category": "Variable",\n      "amount": 100\n    },\n     {\n      "budgetname": "Savings",\n       "category":"Savings",\n      "amount": 417 \n    },\n    {\n      "budgetname": "Others",\n      "category": "Variable",\n      "amount": 2583\n    }\n  ]\n}\n```\n'),
    ]),
    Content.multi([
      TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n6. Others\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      category: Food\n      amount: 200\n    }\n  ]\n}'),
    ]),
    Content.model([
      TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Housing",\n      "category": "Housing",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Food",\n      "category": "Food",\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "category": "Transportation",\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "category": "Entertainment",\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Savings",\n      "category": "Savings",\n      "amount": 417\n    },\n    {\n      "budgetname": "Budget Others",\n      "category": "Others",\n      "amount": 2583\n    }\n  ]\n}\n```\n'),
    ]),
    Content.multi([
      TextPart('Monthly Income: 5000\nEssential Expenses: 2000\nVariable Expenses: 500\nSaving Goals In 10 Years: 50000\n\nBase on these information, create a monthly budget base on these category:\n1. Food\n2. Transportation\n3. Entertainment\n4. Housing\n5. Savings\n\nReturn in JSON format like this:\n{\n  budgets:[\n    {\n      budgetname: Budget Food\n      category: Food\n      amount: 200\n    }\n  ]\n}'),
    ]),
    Content.model([
      TextPart('```json\n{\n  "budgets": [\n    {\n      "budgetname": "Budget Food",\n      "category": "Food",\n      "amount": 400\n    },\n    {\n      "budgetname": "Budget Transportation",\n      "category": "Transportation",\n      "amount": 300\n    },\n    {\n      "budgetname": "Budget Entertainment",\n      "category": "Entertainment",\n      "amount": 100\n    },\n    {\n      "budgetname": "Budget Housing",\n      "category": "Housing",\n      "amount": 1200\n    },\n    {\n      "budgetname": "Budget Savings",\n      "category": "Savings",\n      "amount": 417\n    }\n  ]\n}\n```\n'),
    ]),
  ]);
  final message = 'Hi, How are you';
  final content = Content.text(message);

  final response = await chat.sendMessage(content);
  print(response.text);
}