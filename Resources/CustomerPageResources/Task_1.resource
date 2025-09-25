*** Settings ***
Resource   ../CustomerPageResources/CustomerPage.resource


*** Keywords ***
Go To Customers Page
    [Documentation]    Navigate to Customers page and wait until loaded
    Click Element    ${nav_btn_customer}
    Wait Until Element Is Visible    ${table_row}    20s
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    ${loading_icon}    20s

Create Customer
    [Documentation]    Create a new customer with given json data and verify
    [Arguments]    ${customer}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Text    ${customers_txt_firstname}    ${customer["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}     ${customer["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}        ${customer["email"]}
    Input Text    ${customers_txt_birthday}     ${customer["birthday"]}
    Input Text    ${customers_txt_address}      ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Input Text    ${customers_txt_city}         ${customer["address"]["city"]}
    Input Text    ${customers_txt_stateAbbr}    ${customer["address"]["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}      ${customer["address"]["zipcode"]}
    Input Text    ${customers_txt_password}     ${customer["password"]}
    Input Text    ${customers_txt_confirm_password}    ${customer["password"]}
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Verify Customer Input
    [Arguments]    ${customer}
    ${first_name}    Get Element Attribute    ${customers_txt_firstname}    value
    Should Be Equal As Strings    ${customer["name"].split(" ")[0]}    ${first_name}

    ${second_name}   Get Element Attribute    ${customers_txt_lastname}     value
    Should Be Equal As Strings    ${customer["name"].split(" ")[1]}    ${second_name}

    ${email}         Get Element Attribute    ${customers_txt_email}        value
    Should Be Equal As Strings    ${customer["email"]}    ${email}

    ${birthday}      Get Element Attribute    ${customers_txt_birthday}     value
    ${birthday}=     Format Birthday    ${birthday}
    Should Be Equal As Strings    ${customer["birthday"]}    ${birthday}

    ${address}       Get Element Attribute    ${customers_txt_address}      value
    Should Be Equal As Strings    ${customer["address"]["street"]} ${customer["address"]["suite"]}    ${address}

    ${city}          Get Element Attribute    ${customers_txt_city}         value
    Should Be Equal As Strings    ${customer["address"]["city"]}    ${city}

    ${stateAbbr}     Get Element Attribute    ${customers_txt_stateAbbr}    value
    Should Be Equal As Strings    ${customer["address"]["stateAbbr"]}    ${stateAbbr}

    ${zipcode}       Get Element Attribute    ${customers_txt_zipcode}      value
    Should Be Equal As Strings    ${customer["address"]["zipcode"]}    ${zipcode}

    ${password}      Get Element Attribute    ${customers_txt_password}     value
    Should Be Equal As Strings    ${customer["password"]}    ${password}

    ${confirm_password}    Get Element Attribute    ${customers_txt_confirm_password}    value
    Should Be Equal As Strings    ${customer["password"]}    ${confirm_password}

    &{verified_customer}=    Create Dictionary
    ...    first_name=${first_name}
    ...    last_name=${second_name}
    ...    email=${email}
    ...    birthday=${birthday}
    ...    address=${address}
    ...    city=${city}
    ...    stateAbbr=${stateAbbr}
    ...    zipcode=${zipcode}
    ...    password=${password}
    ...    confirm_password=${confirm_password}
    Append To List    ${Verified_Customers}    ${verified_customer}
    Set Suite Variable    ${Verified_Customers}

    Go To Customers Page
    Refresh Current Page