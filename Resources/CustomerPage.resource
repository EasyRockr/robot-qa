*** Settings ***
Library   SeleniumLibrary
Library    Collections

Resource    App.resource

*** Keywords ***
Go To Customers Page
   Click Element    ${nav_btn_customer}
   Wait Until Element Is Visible    ${table_row}

Create Customer
    [Arguments]    ${customer}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Text    ${customers_txt_firstname}    ${customer["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}    ${customer["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}    ${customer["email"]}
    Input Text    ${customers_txt_birthday}    ${customer["birthday"]}
    Input Text    ${customers_txt_address}    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${customer["address"]["city"]}
    Input Text    ${customers_txt_stateabbr}    ${customer["address"]["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${customer["address"]["zipcode"]}
    Input Text    ${customers_txt_password}    ${customer["password"]}
    Input Text    ${customers_txt_confirm_password}    ${customer["password"]}
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Verify Customer Input
    [Arguments]    ${user}
    ${first_name}    Get Element Attribute    ${customers_txt_firstname}    value
    Log To Console    ${first_name}
    Should Be Equal As Strings    ${user["name"].split(" ")[0]}       ${first_name}
    Log To Console    First Name Input Is Correct

    ${second_name}    Get Element Attribute    ${customers_txt_lastname}    value
    Log To Console    ${second_name}
    Should Be Equal As Strings    ${user["name"].split(" ")[1]}   ${second_name}
    Log To Console    Second Name Input Is Correct

    ${email}    Get Element Attribute    ${customers_txt_email}    value
    Log To Console    ${email}
    Should Be Equal As Strings    ${user["email"]}   ${email}
    Log To Console    Email Input Is Correct

    ${birthday}    Get Element Attribute    ${customers_txt_birthday}    value
    Log To Console    ${birthday}
    ${birthday}=    Format Birthday    ${birthday}
    Should Be Equal As Strings    ${user["birthday"]}    ${birthday}
    Log To Console    Birthday Input Is Correct

    ${address}    Get Element Attribute    ${customers_txt_address}    value
    Log To Console    ${address}
    ${city}    Get Element Attribute    ${customers_txt_city}    value
    Log To Console    ${city}
    ${stateAbbr}    Get Element Attribute    ${customers_txt_stateAbbr}    value
    Log To Console    ${stateAbbr}
    ${zipcode}    Get Element Attribute    ${customers_txt_zipcode}    value
    Log To Console    ${zipcode}
    ${password}    Get Element Attribute    ${customers_txt_password}    value
    Log To Console    ${password}
    ${confirm_password}    Get Element Attribute    ${customers_txt_confirm_password}    value
    Log To Console    ${confirm_password}

# Verify Customer Data Suite Against Customer Input

Verify Created Customer Is Added
    [Arguments]    ${customer}
    Verify Customer Name Is Added    ${customer}
    Verify Customer Email Is Added    ${customer}
    
Verify Customer Name Is Added
    [Arguments]    ${customer}
    Go To Customers Page
    Wait Until Element Is Not Visible    (${table_row})[1]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]
    Wait Until Element Is Visible    (${table_row})[1]//td//div[contains(@class,"MuiAvatar-colorDefault") and text()]
    ${fetched_name}    Get Text     ((${table_row})[1]//td)[2]    
    IF    "\\n" in """${fetched_name}"""
         ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    Should Contain     ${customer["name"]}    ${fetched_name}
    Log To Console    ${fetched_name}


Verify Customer Email Is Added
    [Arguments]    ${customer}
    Go To Customers Page
    Click Element    ((${table_row})[1]//td)[3]
    Wait Until Element Is Visible    //input[@name="email"]    10s
    ${fetched_email}    Get Element Attribute    //input[@name="email"]    value
    ${expected_email}   Get From Dictionary    ${customer}    email
    Should Be Equal     ${expected_email}    ${fetched_email}
    Log To Console      ${fetched_email}


