*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource

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

TEST-000002
    [Documentation]    Get API user and create in Customers
    ${customers}    Get Random Customers
    
    FOR    ${i}    IN    @{customers}
        Go To Customers Page
        Create Customer    ${i}
        Verify Customer Input    ${i}
        # Capture Page Screenshot
    END

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

