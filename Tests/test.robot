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
    ${int_1}    Set Variable    5
    ${int_2}    Set Variable    3
    ${sum}    Evaluate    "${int_1}" + "${int_2}"
    Log To Console    The sum of ${int_1} and ${int_2} is ${sum}

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

