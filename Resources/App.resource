*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables  ../Variables/variables.py


*** Keywords ***
Refresh Current Page
    [Documentation]    Refresh the current page and wait until loading is complete
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}
