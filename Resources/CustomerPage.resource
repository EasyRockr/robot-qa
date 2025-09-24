*** Settings ***
Library   SeleniumLibrary
Variables   ../Variables/customerpage.py
Variables   ../Variables/variables.py

*** Keywords ***
Go To Customers Page
   Click Element    ${nav_btn_customer}
   Wait Until Element Is Visible    //table/tbody//tr

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

Verify Customer Is Added
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
