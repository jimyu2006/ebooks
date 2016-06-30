Feature: Payment/Receipt prechecks 
	Validate payment/receipt transaction to ensure the data is complete and correct
	
Background: Set common valies to test this feature
Given I have a book with the following parameters
	| CashbookID                           | Description  | CashbookStartDate |
	| f50ee246-10b6-49c2-916f-cb54396a039a | Valid book 1 | 01/01/2013        |
And the book has the following settings
	| CashbookID                           | LockoffDate |
	| f50ee246-10b6-49c2-916f-cb54396a039a |             |
And the book has the following country specific values
	| CashbookID                           | Key | Value                      |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 56  | Recon One                  |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 80  | d MMMM yyyy                |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 75  | {0:$#,0.00;-$#,0.00;$0.00} |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 28  | Tax                        |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 29  | tax                        |
And the book has the following tax groups
	| TaxGroupID                           | CashbookID                           | GroupCode | Description    | TaxAgentyID                          | IsEnabled |
	| 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | f50ee246-10b6-49c2-916f-cb54396a039a | GST       | GST on sales   | 40D387C4-4C39-4558-BB44-A233FC7EE521 | true      |
	| 110832b8-9d2a-4145-8295-d2be5bb0d555 | f50ee246-10b6-49c2-916f-cb54396a039a | FRE       | GST free sales | 40D387C4-4C39-4558-BB44-A233FC7EE521 | true      |
And the tax group is selected from all tax goups
	| TaxGroupID                           | CashbookID                           | GroupCode | Description  | TaxAgentyID                          | IsEnabled |
	| 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | f50ee246-10b6-49c2-916f-cb54396a039a | GST       | GST on sales | 40D387C4-4C39-4558-BB44-A233FC7EE521 | true      |
And the tax group has the following tax codes
	| TaxCodeID                            | Code | LongDescription | TaxAgencyID                          | AppliesToReceipts | AppliesToPayments | TaxTypeID                            |
	| 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | GST  | GST on sales    | e306bff6-adee-4af0-94c2-74bb487269d1 | true              | true              | 454cdb9d-e7a6-45ea-9389-b1dc4771274b |
And the tax code has the following tax rates
	| TaxRateID                            | TaxCodeID                            | Rate     | DateFrom   | DateTo     | IsWholeAmountTax |
	| 92be1cc0-8885-4375-ba5d-56730cb5a307 | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 10.00000 | 01/01/2014 | 01/01/2090 | false            |
And the book has the following tax preferences
	| CashbookID                           | TaxAgencyID                          | AccountingMethod | CanUserChangeAmountTaxStatus | DefaultAmountTaxStatus | IsTaxAmountEditable | TaxGroupID                           | ReportLocationTypes | SalesFiguresCollection |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 7818e1d6-4d8d-4206-8150-484d3fceaf81 | 2                | false                        | 2                      | false               | 6ce6ae1b-a7eb-428b-a048-52e3ebc4d915 |                     |                        |
And the book has the following accounts
	| AccountingCategoryID                 | CashbookID                           | CategoryName          | IsDebit | TaxGroupID                           | AccountType | SystemCategory | Status | AccountCode | SortOrder |
	| 1120a991-565e-41b0-8031-0f0eb623a35c | f50ee246-10b6-49c2-916f-cb54396a039a | Income                | false   | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 1           | 0              | 1      | 4-0000      | 1         |
	| 38b12f47-5a48-4a16-83fa-bc7ece473ad9 | f50ee246-10b6-49c2-916f-cb54396a039a | Espense               | true    | 110832b8-9d2a-4145-8295-d2be5bb0d555 | 2           | 0              | 1      | 5-0000      | 2         |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | f50ee246-10b6-49c2-916f-cb54396a039a | Accounts receivable   | true    | 110832b8-9d2a-4145-8295-d2be5bb0d555 | 10          | 0              | 1      | 6-0000      | 4         |
	| 4f171d54-bd94-4438-9240-85c4268f317e | f50ee246-10b6-49c2-916f-cb54396a039a | Accounts payable      | false   | 110832b8-9d2a-4145-8295-d2be5bb0d555 | 15          | 0              | 1      | 7-0000      | 5         |
	| 7ac60c86-a88f-44d6-be6e-bf05b19b8b40 | f50ee246-10b6-49c2-916f-cb54396a039a | Sales                 | false   | 110832b8-9d2a-4145-8295-d2be5bb0d555 | 1           | 0              | 1      | 8-0000      | 6         |
	| 032f91f9-653c-4908-94b4-b74a94c693f5 | f50ee246-10b6-49c2-916f-cb54396a039a | Printing & Stationery | true    | 110832b8-9d2a-4145-8295-d2be5bb0d555 | 2           | 0              | 1      | 9-0000      | 7         |
And the account is selected from all accounts
	| AccountingCategoryID                 | CashbookID                           | CategoryName        | IsDebit | TaxGroupID                           | AccountType | SystemCategory | Status | AccountCode | SortOrder |
	| 1120a991-565e-41b0-8031-0f0eb623a35c | f50ee246-10b6-49c2-916f-cb54396a039a | Income              | false   | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 1           | 0              | 1      | 4-0000      | 1         |
And the book has the following bank accounts
	| BankAccountID                        | CashbookID                           | Description          | DateFrom   | LockoffDate |
	| b62b3ec8-d707-48f4-aa06-109c86e1d973 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid bank account 1 | 01/01/2013 |             |
	| 36ca0a1c-5d67-4c68-ae69-a07c5c6663c8 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid bank account 2 | 11/11/2014 |             |
And the bank account is selected from all book bank accounts
	| BankAccountID                        | CashbookID                           | Description          | DateFrom   | LockoffDate |
	| b62b3ec8-d707-48f4-aa06-109c86e1d973 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid bank account 1 | 01/01/2013 |             |
And the book has the following contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| 434e0d0a-2511-4552-8061-b5388e040438 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer 1          | 1        | 1        | true       | false      | true       | true     |
	| cb42b737-e01b-4fcf-91ca-5fcb0c3d79f9 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid supplier 1          | 1        | 1        | false      | true       | false      | true     |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description      | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| 434e0d0a-2511-4552-8061-b5388e040438 | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer 1 | 1        | 1        | true       | false      | true       | true     |
And the book has the following chargeable items
	| ChargeableItemID                     | CashbookID                           | ItemType | ItemName     | ItemCode | PurchasePrice | PurchaseCategoryID                   | PurchaseDescription | SalePrice     | SaleCategoryID                       | SaleDescription | ActiveStatus | IsTaxInclusive | PurchaseTaxGroupID                   | SaleTaxGroupID | SalePriceAccuracy | PurchasePriceAccuracy | SalePriceIsTaxInclusive | PurchasedSold |
	| 5a910ec4-5212-4f9a-bcfe-4c68a74f2b2b | f50ee246-10b6-49c2-916f-cb54396a039a | 1        | Product item | PI1      | 5.0000000000  | 032f91f9-653c-4908-94b4-b74a94c693f5 |                     | 10.0000000000 | 7ac60c86-a88f-44d6-be6e-bf05b19b8b40 |                 | 1            | 1              |                                      |                | 2                 | 2                     | true                    | 1             |
	| bfa9d56b-03fa-41bd-8e58-7a3b72da91a0 | f50ee246-10b6-49c2-916f-cb54396a039a | 1        | Receipt item |          | 50.0000000000 | 032f91f9-653c-4908-94b4-b74a94c693f5 |                     | 50.0000000000 | 7ac60c86-a88f-44d6-be6e-bf05b19b8b40 |                 | 1            | 1              | 110832b8-9d2a-4145-8295-d2be5bb0d555 |                | 2                 | 2                     | true                    | 2             |
And the chargeable item is selected from all chargeable items
	| ChargeableItemID                     | CashbookID                           | ItemType | ItemName     | ItemCode | PurchasePrice | PurchaseCategoryID                   | PurchaseDescription | SalePrice     | SaleCategoryID                       | SaleDescription | ActiveStatus | IsTaxInclusive | PurchaseTaxGroupID | SaleTaxGroupID | SalePriceAccuracy | PurchasePriceAccuracy | SalePriceIsTaxInclusive | PurchasedSold |
	| 5a910ec4-5212-4f9a-bcfe-4c68a74f2b2b | f50ee246-10b6-49c2-916f-cb54396a039a | 1        | Product item | PI1      | 5.0000000000  | 032f91f9-653c-4908-94b4-b74a94c693f5 |                     | 10.0000000000 | 7ac60c86-a88f-44d6-be6e-bf05b19b8b40 |                 | 1            | 1              |                    |                | 2                 | 2                     | true                    | 3             |

@Test1
Scenario Outline: Check all mandatory fields have been completed for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID | PaymentsReceiptsID | CustomerSupplierID | BankAccountID | TransDate | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	|            |                    |                    |               |           | false     | 100.00 | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has book ID '<CashbookID>'
And this payment has payment ID '<PaymentsReceiptsID>'
And this payment has contact ID '<CustomerSupplierID>'
And this payment has bank account ID '<BankAccountID>'
And this payment has transaction date '<TransDate>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | ExpectedError |
	|                                      | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | 1             |
	| f50ee246-10b6-49c2-916f-cb54396a039a |                                      | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | 2             |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 |                                      | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | 3             |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 |                                      | 01/01/2014 | 4             |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |            | 5             |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | 0             |

@Test2
Scenario Outline: Check a payment bank account and contact exist for the book
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID | BankAccountID | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 |                    |               | 01/01/2014 | false     | 100.00 | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has contact ID '<CustomerSupplierID>'
And this payment has bank account ID '<BankAccountID>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| CustomerSupplierID                   | BankAccountID                        |  ExpectedError |
	| 434e0d0a-2511-4552-8061-b5388e040438 | 054f5a94-fa96-4121-9de5-e320c7605df4 |  6             |
	| 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |  0             |
	| dd096d5b-b9ca-4089-afea-454dccc8d6e8 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |  7             |
	| 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |  0             |

@Test4
Scenario Outline: Check payment or receipt trasaction date is within a date range
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |           | false     | 100.00 | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has transaction date '<TransDate>'
And the book start date '<BookStartDate>'
And the book lockoff date '<BookLockoffDate>'
And the bank account start date '<BankAccountStartDate>'
And the bank account end date '<BankAccountEndDate>'
And the bank account lockoff date '<BankAccountLockoffDate>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| TransDate   | BookStartDate | BookLockoffDate | BankAccountStartDate | BankAccountEndDate | BankAccountLockoffDate | ExpectedError |
	| 01/01/2014  | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         |                        | 0             |
	| 02/01/2014  | 03/01/2014    |                 | 03/01/2014           | 01/01/9999         |                        | 63            |
	| Today + 400 | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         |                        | 65            |
	| Today       | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         |                        | 0             |
	| 03/01/2014  | 01/01/2013    | 03/01/2014      | 01/01/2013           | 01/01/9999         |                        | 64            |
	| 02/01/2014  | 01/01/2013    | 03/01/2014      | 01/01/2013           | 01/01/9999         |                        | 64            |
	| 04/01/2014  | 01/01/2013    | 03/01/2014      | 01/01/2013           | 01/01/9999         |                        | 0             |
	| 05/01/2014  | 01/01/2013    |                 | 06/01/2014           | 01/01/9999         |                        | 18            |
	| 06/01/2014  | 01/01/2013    |                 | 01/01/2013           | 05/01/2014         |                        | 19            |
	| 07/01/2014  | 01/01/2013    |                 | 01/01/2013           | 08/01/2014         |                        | 0             |
	| 08/01/2014  | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         | 09/01/2014             | 17            |
	| 08/01/2014  | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         | 08/01/2014             | 17            |
	| 09/01/2014  | 01/01/2013    |                 | 01/01/2013           | 01/01/9999         | 08/01/2014             | 0             |

@Test5
Scenario Outline: Check max field length allowed for payment fields
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | false     | 100.00 | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has narration '<Narration>'
And this payment has details '<Details>'
And this payment has reference '<Reference>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Narration                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Details                                                                                                                                                                                                                                                        | Reference                                                                                                                                                                                                    | ExpectedError |
	| (Over 400 chars) 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 |                                                                                                                                                                                                                                                                |                                                                                                                                                                                                              | 8             |
	|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | (Over 255 chars) 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 |                                                                                                                                                                                                              | 9             |
	|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |                                                                                                                                                                                                                                                                | (Over 200 chars) 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 | 10            |
	| 1234567890                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 1234567890                                                                                                                                                                                                                                                     | 1234567890                                                                                                                                                                                                   | 0             |

@Test6
Scenario Outline: Check allowed decimal values of the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has amount '<Amount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Amount                | ExpectedError |
	| 922337203685477.58079 | 20            |
	| 0.58079               | 21            |
	| 100.5807              | 0             |

@Test7
Scenario Outline: Check base cash allocation values of the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      |        | true               | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID | PaymentsReceiptsID | AccountingCategoryID | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	|                                 |                    |                      | 50.55            |               | false               |            |           |                  | 0.0000 |          |                |                 |         |             | 4            | 1          |
And this payment has amount '<Amount>'
And the payment amount is '<IsTaxApplicable>'
And this payment has accounting split ID '<PaymentReceiptAccountingSplitID>'
And this payment has accounting split payment ID '<PaymentsReceiptsID>'
And this payment has accounting split accounting category ID '<AccountingCategoryID>'
And this payment has accounting split chargeable item ID '<ChargeableItemID>'
And this payment has accounting split tax group ID '<TaxGroupID>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | ChargeableItemID                     | IsTaxApplicable | TaxGroupID                           | Amount | ExpectedError |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                                      | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 50.00  | 12            |
	|                                      | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                                      | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 23            |
	| 8f466df0-8da6-43ec-b180-1078715240ae |                                      | 1120a991-565e-41b0-8031-0f0eb623a35c |                                      | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 24            |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 |                                      |                                      | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 25            |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 |                                      | 5a910ec4-5212-4f9a-bcfe-4c68a74f2b2b | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 26            |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                                      | false           | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 27            |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c | 5a910ec4-5212-4f9a-bcfe-4c68a74f2b2b | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 32            |
	| 8f466df0-8da6-43ec-b180-1078715240ae | 78efe31b-2afe-4899-bc87-6a27151994d7 | 032f91f9-653c-4908-94b4-b74a94c693f5 | bfa9d56b-03fa-41bd-8e58-7a3b72da91a0 | true            | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 | 100.00 | 0             |

@Test8
Scenario Outline: Check cash allocation quantity value for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount   | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 100.5807 | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c | 100.5807         |               | false               |            |           |                  | 0.0000 |          |                |                 |         |             | 4            | 1          |
And this payment line item has quantity '<Quantity>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Quantity              | ExpectedError |
	| 922337203685477.58079 | 20            |
	| 0.58079               | 21            |
	| 100.5807              | 0             |

@Test9
Scenario Outline: Check cash allocation discount amount for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 80     | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 2.0000 | 40       |                |                 |         |             | 4            | 1          |
And this payment line item has discount amount  '<DiscountAmount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| DiscountAmount        | ExpectedError |
	| 922337203685477.58079 | 20            |
	| 0.58079               | 21            |
	| 200                   | 36            |
	| 80                    | 0             |

@Test10
Scenario Outline: Check cash allocation discount percentage for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 100    | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 2.0000 | 50       |                |                 |         |             | 4            | 1          |
And this payment line item has discount percentage  '<DiscountPercent>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| DiscountPercent       | ExpectedError |
	| 922337203685477.58079 | 20            |
	| 0.58079               | 21            |
	| 100.5                 | 37            |
	| 100                   | 0             |

@Test11
Scenario Outline: Check cash allocation discount tax amount for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |        | 01/01/2014 | false     | true      |                    | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 0.0000 |          |                |                 |         |             | 4            | 1          |
And this payment line item has discount tax amount '<DiscountTax>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| DiscountTax           | ExpectedError |
	| 922337203685477.58079 | 20            |
	| 0.58079               | 21            |
	| 100.5807              | 0             |

@Test12
Scenario Outline: Check cash allocation line item amount for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |        | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 0.0000 |          |                |                 | 0.0000  |             | 4            | 1          |
And this payment has amount '<Amount>'
And this payment line item has amount '<AccountingAmount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Amount                | AccountingAmount      | ExpectedError |
	| 922337203685477.58079 | 922337203685477.58079 | 20            |
	| 0.58079               | 0.58079               | 21            |
	| 100.5807              | 100.5807              | 0             |

@Test13
Scenario Outline: Check cash allocation line item GST amount for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 |        | 01/01/2014 | false     | true      |                    | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 0.0000 |          |                |                 | 0.0000  |             | 4            | 1          |
And this payment has amount '<Amount>'
And this payment line item has amount '<AccountingAmount>'
And this payment line item has GST amount '<AccountingGST>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Amount                | AccountingAmount      | AccountingGST         | ExpectedError |
	| 922337203685477.58079 | 922337203685477.58079 | 922337203685477.58079 | 20            |
	| 0.58079               | 0.58079               | 0.58079               | 21            |
	| 201.16                | 100.5807              | 100.5807              | 0             |

@Test14
Scenario Outline: Check tax group used in cash allocation line item for the single payment/receipt
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | Amount | TransDate  | IsPayment | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 100    | 01/01/2014 | false     | true               |                           | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID                           | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c | 100              |               | false               | 0a5555c9-1211-4d5b-9a1c-28cb17562c30 |           |                  | 0.0000 |          |                |                 | 0.0000  |             | 4            | 1          |
And the payment line item has tax group '<TaxGroup>'
And the tax group is enabled '<IsEnabled>'
And this payment has transaction date '<TransDate>'
And the tax code is set to be as whole tax amount '<IsWholeAmountTax>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| TaxGroup | IsEnabled | TransDate  | IsWholeAmountTax | ExpectedError |
	| 'NULL'   |           | 01/01/2014 |                  | 29            |
	|          | false     | 01/01/2014 |                  | 30            |
	|          | true      | 01/01/2013 |                  | 31            |
	|          | true      | 01/01/2014 | true             | 705           |
	|          | true      | 01/01/2014 |                  | 0             |

@Test15
Scenario Outline: Check payment/receipt values based on amount tax status
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 500.00 | true               | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate   | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 0.0000 |          |                |                 |         |             | 4            | 1          |
And the payment amount is '<IsTaxApplicable>'
And this payment line item has amount '<AccountingAmount>'
And this payment line item has GST amount '<AccountingGST>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| IsTaxApplicable | AccountingAmount | AccountingGST | ExpectedError |
	| false           | 450.00           | 50.00         | 33            |
	| true            | 50.00            | 450.00        | 34            |
	| true            | -50.00           | -450.00       | 34            |
	| true            | 450.00           | -50.00        | 35            |
	| true            | -450.00          | 50.00         | 35            |
	| true            | 450.00           | 50.00         | 0             |

@Test16
Scenario Outline: Check rate and accuracy values for the payment/receipt cash allocation line item
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID         |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 500.00 | true               | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e |
And this payment has following cash allocations
	| PaymentReceiptAccountingSplitID      | PaymentsReceiptsID                   | AccountingCategoryID                 | AccountingAmount | AccountingGST | GSTManuallyModified | TaxGroupID | ProjectID | ChargeableItemID | Rate | Quantity | DiscountAmount | DiscountPercent | RateTax | DiscountTax | RateAccuracy | LineNumber |
	| dfe6b303-57e3-4792-9bf9-c804f0b5ff7e | 78efe31b-2afe-4899-bc87-6a27151994d7 | 1120a991-565e-41b0-8031-0f0eb623a35c |                  |               | false               |            |           |                  | 0    |          |                |                 |         |             | 0            | 1          |
And this payment line item has rate '<Rate>'
And this payment line item has rate accuracy '<RateAccuracy>'
And this payment line item has rate tax '<RateTax>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| Rate          | RateAccuracy | RateTax       | ExpectedError |
	| 1.0000        | -1           | 1.0000        | 700           |
	| 1.0000        | 11           | 1.0000        | 700           |
	| 0             | 10           | 0             | 701           |
	| 1.12345678909 | 10           | 1.0000        | 702           |
	| 1.1234567890  | 10           | 1.12345678909 | 703           |
	| 1.1234567890  | 10           | 1.1234567890  | 0             |

@Test18
Scenario Outline: Check whether accounts payable or receivable requred or not for payment transaction to allocate a creditor amount
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 500.00 | false              |                           |                              |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4f171d54-bd94-4438-9240-85c4268f317e | 7              | 200.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4f171d54-bd94-4438-9240-85c4268f317e | 7              | 10.00  |
And this payment has accounts payable account '<AccountsPayableCategoryID>'
And this payment has accounts receivalbe account '<AccountsReceivableCategoryID>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	 | AccountsPayableCategoryID            | AccountsReceivableCategoryID         | IsSamePayableReceivableAccount | ExpectedError |
	 |                                      |                                      | true                           | 45            |
	 | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 48            |
	 | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | true                           | 0             |

@Test19
Scenario Outline: Check whether accounts payable or receivable requred or not for receipt transaction to allocate a debtor amount
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | false     | 500.00 | false              |                           |                              |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 8              | 100.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 2              | 10.00  |
And this payment has accounts payable account '<AccountsPayableCategoryID>'
And this payment has accounts receivalbe account '<AccountsReceivableCategoryID>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| AccountsPayableCategoryID            | AccountsReceivableCategoryID         | IsSamePayableReceivableAccount | ExpectedError |
	|                                      |                                      | true                           | 46            |
	| 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 47            |
	|                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |

@Test20
Scenario Outline: Check creditor amounts are allocated to the same accounts payable account for payment transaction
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | 434e0d0a-2511-4552-8061-b5388e040438 | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 500.00 | false              |                           |                              |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 8              | 100.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 2              | 10.00  |
And the debtor/creditor allocation type is '<AllocationType>'
And this payment has accounts payable account '<AccountsPayableCategoryID>'
And this payment has accounts receivalbe account '<AccountsReceivableCategoryID>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| AllocationType | AccountsPayableCategoryID            | AccountsReceivableCategoryID         | IsSamePayableReceivableAccount | ExpectedError |
	| 2              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | false                          | 51            |
	| 2              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | true                           | 0             |
	| 4              | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | false                          | 57            |
	| 4              | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |
	| 5              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | false                          | 50            |
	| 5              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | true                           | 0             |
	| 7              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | false                          | 49            |
	| 7              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | true                           | 0             |
	| 9              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | false                          | 53            |
	| 9              | 4f171d54-bd94-4438-9240-85c4268f317e |                                      | true                           | 0             |

@Test21
Scenario Outline: Check debtor amounts are allocated to the same accounts receivable account for receipt transaction
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | f218dc69-98e2-4b28-9a9b-644be9541d9d | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | false     | 500.00 | false              |                           |                              |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 8              | 100.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 2              | 10.00  |
And the debtor/creditor allocation type is '<AllocationType>'
And this payment has accounts payable account '<AccountsPayableCategoryID>'
And this payment has accounts receivalbe account '<AccountsReceivableCategoryID>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| AllocationType | AccountsPayableCategoryID            | AccountsReceivableCategoryID         | IsSamePayableReceivableAccount | ExpectedError |
	| 1              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | false                          | 56            |
	| 1              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |
	| 3              | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | false                          | 52            |
	| 3              | 4f171d54-bd94-4438-9240-85c4268f317e | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |
	| 6              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | false                          | 55            |
	| 6              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |
	| 8              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | false                          | 54            |
	| 8              |                                      | 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | true                           | 0             |

@Test22
Scenario Outline: Check allocation details are valid and available creditor transactions can be allocated for the payment
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | f218dc69-98e2-4b28-9a9b-644be9541d9d | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 500.00 | false              | 4f171d54-bd94-4438-9240-85c4268f317e |                              |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 100.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 351b9b5f-e941-46a4-9de8-1a53a1235a7a | 2              | 10.00  |
	| 649e108f-b63e-4eba-a202-9d27c9beb39a | 7              | 20.00  |
	| c2682b6f-68e2-4574-b114-3a5b4cee4688 | 9              | 30.00  |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 100.00 |
And the debtor/creditor allocation reference ID is '<RefID>'
And the debtor/creditor allocation type is '<AllocationType>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| RefID                                | AllocationType | IsSamePayableReceivableAccount | ExpectedError |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 0              | true                           | 58            |
	| 649e108f-b63e-4eba-a202-9d27c9beb39a | 7              | true                           | 0             |
   #|                                      | 8              | true                           | 59            | This error can't be tested as it's never triggered because the precheck method handles matching references at earlier stage.
   #| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | true                           | 60            | This error can't be tested as GetAllocatedTotalAtTransactionDate throws an exception first if the data mockup in this scenario satisfies error conditions.

@Test23
Scenario Outline: Check an amount to be allocated to the creditor transaction can't be greater than a balance owing
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | f218dc69-98e2-4b28-9a9b-644be9541d9d | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 600.00 | false              | 4f171d54-bd94-4438-9240-85c4268f317e |                              |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 600.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 10.00  |
And the debtor/creditor allocation reference ID is '<RefID>'
And the debtor/creditor allocation amount is '<AllocationAmount>'
And the debtor/creditor balance owing is '<BalanceOwing>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| RefID                                | AllocationAmount | BalanceOwing | IsSamePayableReceivableAccount | ExpectedError |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 600.00           | 500.00       | true                           | 61            |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 300.00           | 300.00       | true                           | 0             |

@Test23
Scenario Outline: Check a creditor status can be changed for the creditor transaction
Given I have a new payment with the following parameters
	| CashbookID                           | PaymentsReceiptsID                   | CustomerSupplierID                   | BankAccountID                        | TransDate  | IsPayment | Amount | AllocateFullAmount | AccountsPayableCategoryID            | AccountsReceivableCategoryID |
	| f50ee246-10b6-49c2-916f-cb54396a039a | 78efe31b-2afe-4899-bc87-6a27151994d7 | f218dc69-98e2-4b28-9a9b-644be9541d9d | b62b3ec8-d707-48f4-aa06-109c86e1d973 | 01/01/2014 | true      | 600.00 | false              | 4f171d54-bd94-4438-9240-85c4268f317e |                              |
And the contact is selected from all book contacts
	| CustomerSupplierID                   | CashbookID                           | Description               | Category | IsPerson | IsCustomer | IsSupplier | IsEmployee | IsActive |
	| f218dc69-98e2-4b28-9a9b-644be9541d9d | f50ee246-10b6-49c2-916f-cb54396a039a | Valid customer/supplier 1 | 1        | 1        | true       | true       | true       | true     |
And this payment has following debtor/creditor allocations
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 600.00 |
And this payment has the following available debtor/creditor transactions to be allocated
	| RefID                                | AllocationType | Amount |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 7              | 10.00  |
And the debtor/creditor allocation reference ID is '<RefID>'
And the debtor/creditor allocation amount is '<AllocationAmount>'
And the debtor/creditor balance owing is '<BalanceOwing>'
And the same accounts payable or receivable account is used for transaction '<IsSamePayableReceivableAccount>'
When I call the GetSaveTransactionPrecheckErrors method 
Then The error number '<ExpectedError>' occurs 
Examples: 
	| RefID                                | AllocationAmount | BalanceOwing | IsSamePayableReceivableAccount | ExpectedError |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 600.00           | 500.00       | true                           | 61            |
	| 4e310c7b-ad07-43cd-a285-2bc3e4f26a1e | 300.00           | 300.00       | true                           | 0             |
