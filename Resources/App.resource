*** Settings ***
Library    SeleniumLibrary
Library    ../Library/CustomLibrary.py
Variables  ../Variables/variables.py
Variables   ../Variables/customerpage.py
Variables   ../Variables/variables.py

*** Keywords ***
Refresh Current Page
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}
    Log To Console    ${USERNAME}
