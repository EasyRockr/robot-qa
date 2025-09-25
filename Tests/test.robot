*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    ../Library/CustomLibrary.py
Resource   ../Resources/App.resource
Resource   ../Resources/CustomerPage.resource
Variables  ../Variables/variables.py
Variables  ../Variables/customerpage.py

Suite Setup    Launch Browser
# Test Teardown    Capture Page Screenshot
Library    String

*** Variables ***
${URL}        https://marmelab.com/react-admin-demo
${USERNAME}   demo
${PASSWORD}   demo

*** Test Cases ***
TEST-000001
    [Documentation]    Login to React Admin demo
    Login User

    ${customers}    Get Random Customers
    Go To Customers Page

    ${Verified_Customers} =    Create List
    Set Suite Variable    ${Verified_Customers}

    FOR    ${customer}    IN    @{customers}
        Create Customer    ${customer}
        Verify Customer Input    ${customer}
    END

    Log To Console    ${Verified_Customers}

    ${total}=    Get Length    ${customers}
    ${end}=      Evaluate    ${total} + 1
    FOR    ${index}    IN RANGE    1    ${end}
        ${customer_index}=    Evaluate    ${total} - ${index}
        ${customer}=    Set Variable    ${customers}[${customer_index}]
        Verify Customer Data    ${customer}    ${index}
    END

TEST-000002
    ${customers}=    Get Random Customers    5    5   # start=5, limit=5 => users 6..10
    Update Customer Table    ${customers}
    # Sleep    500s

TEST-000003
    [Documentation]    TASK 4: Log table data for each row (Name, Last seen, Orders, etc.)
    Get Table Row Data


*** Keywords ***
Launch Browser
    [Arguments]    ${url}=${URL}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
    Wait Until Element Is Visible    ${login_txt_username}    20s

Login User
    [Arguments]    ${username}=${USERNAME}   ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button  ${login_btn_submit}

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${dashboard_hdr}

    IF    ${status}
        Log To Console    Login Successful
    ELSE
        Log To Console    Login Failed
    END

