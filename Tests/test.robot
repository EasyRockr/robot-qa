*** Settings ***
Library    SeleniumLibrary
Library    String
Variables  ../Variables/variables.py
Library    ../Library/CustomLibrary.py

Suite Setup    Launch Browser

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
    # ${users}    Get Random Users
    # Go To Customers Page
    # Create User    ${users[0]}
    # Go To Customers Page
    # Verify User Is Added    ${users[0]}
    # Capture Page Screenshot
    ${users}    Get Random Users
    FOR    ${i}    IN    @{users}
        Go To Customers Page
        Create User    ${i}
        Go To Customers Page
        Verify User Is Added    ${i}
        Capture Page Screenshot
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

Go To Customers Page
    Click Element    ${nav_btn_customer}
    Wait Until Element Is Visible   //table//tr

Create User
    [Arguments]    ${user}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}

    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}     ${user["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}        ${user["email"]}
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}
    Input Text    ${customers_txt_address}    ${user["address"]["street"]} ${user["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}
    Input Text    ${customers_txt_stateabbr}    ${user["address"]["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}

    Input Text    ${customers_txt_password}     ${user["password"]}
    Input Text    ${customers_txt_confirmpassword}    ${user["password"]}
    Click Button  ${customers_btn_save}

    Wait Until Page Contains    Customer created

Verify User Is Added
    [Arguments]    ${user}
    Sleep    2s
    # Wait Until Page Contains    ${user["name"]}
    ${fetched_name}    Get Text    ((//table//tbody//tr)[1]//td)[2]
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    
    Should Contain    ${user["name"]}    ${fetched_name}
    Log To Console    ${fetched_name}
        















#ACT7
# //table//tbody//tr

    # ${users}    Get Random Users
    # ${evaluate}    Evaluate    ${users}
    # Log    evaluate:${evaluate}
    # FOR    ${i}    IN    @{users}
    #     Log To Console    ${i['name']}
    # END
# *** Settings ***
# Library    SeleniumLibrary
# Variables  ../Variables/variables.py
# Library    ../Library/CustomLibrary.py

# Suite Setup    Launch Browser    


# *** Variables ***
# ${URL}        https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
# ${USERNAME}   Admin
# ${PASSWORD}   admin123

# *** Test Cases ***
# TEST-000001
#     [Documentation]    Login to OrangeHRM and verify Dashboard loads.
#     Launch Browser    ${URL}
#     Login User        ${USERNAME}    ${PASSWORD}
#     Capture Page Screenshot
#     [Teardown]    Close Browser


# *** Keywords ***
# Launch Browser
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
#     Wait Until Element Is Visible    ${login_txt_username}    20s

# Login User
#     [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
#     Input Text    ${login_txt_username}    ${username}
#     Input Text    ${login_txt_password}    ${password}
#     Click Button  ${login_btn_submit}

#     ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${dashboard_hdr}    10s

#     IF    ${status}
#         Log To Console    Login Successful
#     ELSE











#ACT6:
# *** Settings ***
# Library    SeleniumLibrary
# Variables  ../Variables/variables.py

# *** Variables ***
# ${URL}        https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
# ${USERNAME}   Admin
# ${PASSWORD}   admin123


# *** Test Cases ***
# TEST-000001
#     [Documentation]    Login to OrangeHRM and verify Dashboard loads.
#     Launch Browser    ${URL}
#     Login User        ${USERNAME}    ${PASSWORD}
#     Wait Until Page Contains Element    //h6[normalize-space()="Dashboard"]    20s
#     Capture Page Screenshot
#     [Teardown]    Close Browser

# *** Keywords ***
# Launch Browser
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
#     Wait Until Element Is Visible    ${login_txt_username}    20s

# Login User
#     [Arguments]    ${username}=${USERNAME}   ${password}=${PASSWORD}
#     Input Text    ${login_txt_username}    ${username}
#     Input Text    ${login_txt_password}    ${password}
#     Click Button  ${login_btn_submit}
#     # Wait Until Element Is Visible    ${dashboard_hdr}

#     ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${dashboard_hdr}

#     IF    ${status}
#         Log To Console    Login Successful
#     ELSE
#         Log To Console    Login Failed
#     END

# #OTHERS:
# Suite Setup    Launch Browser
# Suite Teardown    Data Cleanup
# Test Setup    Launch Browser
# Test Teardown    Data Cleanup


# # FOR LOOP

# ${VAR_1}      STRING_1
# @{LIST_1}     VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}     key_1=value_1    key_2=value_2    key_3=VALUE_3
# FOR $(i) IN @{LIST_1}
#     Log To Console    ${i}
# END
# FOR $(i) IN 0 3
#     Log To Console    ${LIST_1[${i}]}
# END
# FOR $(i) IN @{DICT_1.keys()}
#     Log To Console    ${i}:${DICT_1["${i}"]}
# END


# LOGS:
#  ${return_value} Launch Browser    https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
#     Log    ${return_value}

# keyworkd:
#     Return From Keyword    KAHIT ANO


#ACT5 IFRAME:
# *** Settings ***
# Library    SeleniumLibrary
# Variables  ../Variables/variables.py

# *** Variables ***
# ${VAR_1}      STRING_1
# @{LIST_1}     VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}     key_1=value_1    key_2=value_2    key_3=VALUE_3

# *** Test Cases ***
# TEST-000001
#     [Documentation]    This is a sample test case.
#     Launch Browser    https://demo.prestashop.com/#/en/front
#     Switch To Storefront Iframe
#     Wait Until Page Contains Element    ${search_box}    30s
#     Click Element    ${search_box}
#     Input Text    ${search_txt_input}    Mug the adventure begins
#     Press Keys    ${search_txt_input}    ENTER
#     Sleep    5s
#     [Teardown]    Close Browser

# *** Keywords ***
# Launch Browser
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")

# Switch To Storefront Iframe
#     Wait Until Element Is Visible    ${framelive_iframe}    30s
#     Select Frame    ${framelive_iframe}



# ACT4
# *** Settings ***
# Library    SeleniumLibrary
# Variables    ../Variables/variables.py

# *** Variables ***
# ${VAR_1}      STRING_1
# @{LIST_1}     VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}     key_1=value_1    key_2=value_2    key_3=VALUE_3

# *** Test Cases ***
# TEST-000001
#     [Documentation]    This is a sample test case.
#     Launch Browser    https://demo.prestashop.com/#/en/front
#     Sleep    5s

# *** Keywords ***
# Launch Browser
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
#     # Wait Until Keyword Succeeds    retry    retry_interval    name
#     Wait Until Keyword Succeeds    5x    5s    Wait Until Element Is Not Visible   ${loading_message} ${search_bar}






















# 3rd
# *** Settings ***
# Library    SeleniumLibrary
# Variables    ../Variables/variables.py

# *** Variables ***
# ${VAR_1}      STRING_1
# @{LIST_1}     VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}     key_1=value_1    key_2=value_2    key_3=VALUE_3

# *** Test Cases ***
# TEST-000001
#     [Documentation]    This is a sample test case.
#     Launch Browser    https://demo.prestashop.com/#/en/front
#     Sleep    100s

# *** Keywords ***
# Launch Browser
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
#     #Wait Until Element Is Not Visible    ${loading_message} 10s












# *** Settings ***
# Library    SeleniumLibrary
# Variables    ../Variables/variables.py

# *** Variables ***
# ${VAR_1}      STRING_1
# @{LIST_1}     VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}     key_1=value_1    key_2=value_2    key_3=VALUE_3

# *** Test Cases ***
# TEST-000001
#     [Documentation]    This is a sample test case.
#     Launch Youtube    https://www.youtube.com
#     Input Text    ${search_txt_input}    Robin Discaya
#     Press Keys    ${search_txt_input}    ENTER
#     Sleep    3s

# *** Keywords ***
# Launch Youtube
#     [Arguments]    ${url}
#     Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
#     Wait Until Element Is Visible    ${search_txt_input}


















# *** Settings ***
# Library    SeleniumLibrary
# Variables    variables.py

# *** Variables ***
# ${VAR_1}    STRING_1
# @{LIST_1}   VALUE_1    VALUE_2    VALUE_3
# &{DICT_1}   key_1=value_1    key_2=value_2    key_3=VALUE_3


# *** Test Cases ***
# TEST-000001
#     [Documentation]    This is a sample test case.
#     Log to Console    Hello World
#     Log to Console    ${CURDIR}
#     Log to Console    ${VAR_1}
#     Log to Console    ${LIST_1}
#     Log to Console    ${DICT_1}
#     ${test_case_var}    Set Variable    TEST_CASE_VAR
#     Log To Console    ${test_case_var}

#     Open Browser    https://www.google.com    chrome    options=add_argument("--start-minimized");
#     # Wait Until Element Is Visible    locator
#     # Wait Until Element Is Visible    id=APjFqb
#     # Wait Until Element Is Visible    name=q
#     # Wait Until Element Is Visible    class=gLFyf
#     # ${search_bar}    Set Variable    '//div[@class="SDkEP"]'
#     Wait Until Element Is Visible    ${search_bar}//text_area
#     # Sleep    5s

# *** Keywords ***
# Launch Google
#     Open Browser    https://www.google.com
