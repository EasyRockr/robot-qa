*** Settings ***
Resource   ../CustomerPageResources/CustomerPage.resource


*** Keywords ***
Update Customer Table
    [Documentation]    Update existing customers with new json data and verify
    [Arguments]    ${customers}
    ${total}    Get Length    ${customers}
    ${end}      Evaluate    ${total} + 1

    FOR    ${index}    IN RANGE    1    ${end}
        ${customer_index}    Evaluate    ${index} - 1
        ${customer}          Set Variable    ${customers}[${customer_index}]

        Go To Customers Page
        Open Customer By Index    ${index + 5}    
        Wait Until Element Is Visible    ${customers_txt_firstname}

        Clear And Input Text    ${customers_txt_firstname}  ${customer["name"].split(" ")[0]}
        Clear And Input Text    ${customers_txt_lastname}   ${customer["name"].split(" ")[1]}
        Clear And Input Text    ${customers_txt_email}    ${customer["email"]}
        Input Text    ${customers_txt_birthday}    ${customer["birthday"]}
        Clear And Input Text    ${customers_txt_address}    ${customer["address"]["street"]} ${customer["address"]["suite"]}
        Clear And Input Text    ${customers_txt_city}    ${customer["address"]["city"]}
        Clear And Input Text    ${customers_txt_stateAbbr}    ${customer["address"]["stateAbbr"]}
        Clear And Input Text    ${customers_txt_zipcode}    ${customer["address"]["zipcode"]}
        Clear And Input Text    ${customers_txt_password}    ${customer["password"]}
        Clear And Input Text    ${customers_txt_confirm_password}     ${customer["password"]}

        Click Button    ${customers_btn_save}
        Wait Until Page Contains    Customer updated

        Verify Customer Data    ${customer}    ${index + 5}
    END


Clear And Input Text
    [Documentation]    Clear existing text and input new text into a field
    [Arguments]    ${locator}    ${value}
    Click Element    ${locator}
    # For Windows/Linux, use CTRL instead of COMMAND
    Press Keys       ${locator}    CTRL+a    BACKSPACE
    # For MacOS, use COMMAND instead of CTRL
    # Press Keys       ${locator}    COMMAND+a    DELETE
    Input Text       ${locator}    ${value}