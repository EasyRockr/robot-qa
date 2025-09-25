*** Settings ***
Library    SeleniumLibrary
Library    ../Library/CustomLibrary.py
Library    Collections
Variables  ../Variables/customerpage.py
Resource   App.resource

*** Keywords ***
Go To Customers Page
    Click Element    ${nav_btn_customer}
    Wait Until Element Is Visible    ${table_row}    20s
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    ${loading_icon}    20s


Create Customer
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

Open Customer By Index
    [Arguments]    ${index}
    ${locator}=    Set Variable    //table//tbody//tr[${index}]//td[2]//a
    Click Element    ${locator}
    Wait Until Element Is Visible    ${customers_txt_firstname}

Verify Customer Data
    [Arguments]    ${customer}    ${index}
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}
    Open Customer By Index    ${index}
    Verify Customer Input    ${customer}



Update Customer Table
    [Arguments]    ${customers}
    ${total}=    Get Length    ${customers}
    ${end}=      Evaluate    ${total} + 1

    FOR    ${index}    IN RANGE    1    ${end}
        ${customer_index}=    Evaluate    ${index} - 1
        ${customer}=          Set Variable    ${customers}[${customer_index}]

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
    [Arguments]    ${locator}    ${value}
    Click Element    ${locator}
    # macOS
    Press Keys       ${locator}    COMMAND+a    DELETE
    Input Text       ${locator}    ${value}

# TASK4
Get Table Row Data
    [Documentation]    TASK 4: For each row in the table, print user data in the required format.
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}

    ${row_count}=    Get Element Count    ${table_row}
    ${end}=          Evaluate    ${row_count} + 1

    FOR    ${r}    IN RANGE    1    ${end}
        ${name}=              Get Text    //table//tbody//tr[${r}]//td[2]//a
        ${last_seen}=         Get Text    //table//tbody//tr[${r}]//td[3]
        ${orders}=            Get Text    //table//tbody//tr[${r}]//td[4]
        ${total_spent}=       Get Text    //table//tbody//tr[${r}]//td[5]
        ${latest_purchase}=   Get Text    //table//tbody//tr[${r}]//td[6]

        # News icon may not exist on some rows — check first
        ${has_news}=    Run Keyword And Return Status    Page Should Contain Element    //table//tbody//tr[${r}]//td[7]//*[name()="svg"]
        IF    ${has_news}
            ${news}=    Get Element Attribute    //table//tbody//tr[${r}]//td[7]//*[name()="svg"]    aria-label
        ELSE
            ${news}=    Set Variable    No
        END

        # Collect segment chips (0..n), join with commas
        @{chip_nodes}=    Get WebElements    //table//tbody//tr[${r}]//td[8]//span[contains(@class,"MuiChip-label")]
        ${segments}=       Create List
        FOR    ${chip}    IN    @{chip_nodes}
            ${txt}=    Get Text    ${chip}
            Append To List    ${segments}    ${txt}
        END
        ${segment}=    Catenate    SEPARATOR=,     @{segments}

        Log To Console    ====== User ${r} ======
        Log To Console    Name: ${name}
        Log To Console    Last seen: ${last_seen}
        Log To Console    Orders: ${orders}
        Log To Console    Total spent: ${total_spent}
        Log To Console    Latest purchase: ${latest_purchase}
        Log To Console    News: ${news}
        Log To Console    Segment: ${segment}
        Log To Console    --------------------------------------------
    END
