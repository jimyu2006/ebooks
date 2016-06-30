Feature: MockProvisioning
	Test the mock provisioning

@mocktest1
Scenario: Test mock provisioning
	Given the book contains the following modules
	| ProductID | ProductDescription  |
	| CCOL0AD1M | Core                |
	| RKNON0P   | ProjectsLarge       |
	| RKNON0I   | InvoicingLarge      |
	| RKNON0T   | TimeAndExpenseLarge |
	| CGVC0AD1M | GovconnectSmall     |
	| CBDA0AD1M | BankDataLarge       |
	When Getting reports for group 'Customers'
	Then i should get the following reports
	| ReportName              |
	| Aged debtors             |
	| Aged debtor transactions |
	| Invoice list             |
	| Customer transactions    |
	| Unpaid invoices          |


