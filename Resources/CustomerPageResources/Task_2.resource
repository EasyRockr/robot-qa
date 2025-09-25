*** Settings ***
Resource   ../CustomerPageResources/CustomerPage.resource


*** Keywords ***
Open Customer By Index
    [Documentation]    Open customer details by table index
    [Arguments]    ${index}
    ${locator}    Set Variable    ${name_selector % ${index}}
    Click Element    ${locator}
    Wait Until Element Is Visible    ${customers_txt_firstname}

Verify Customer Data
    [Documentation]    Verify customer data by reopening each customer by index
    [Arguments]    ${customer}    ${index}
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}
    Open Customer By Index    ${index}
    Verify Customer Input    ${customer}