*** Settings ***
Resource   App.resource


*** Keywords ***
Launch Browser
    [Documentation]    Launch browser and navigate to URL, wait until login page is visible
    [Arguments]    ${url}=${URL}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
    Wait Until Element Is Visible    ${login_txt_username}    20s

Login User
    [Documentation]    Login with given username and password, default to env variables
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
