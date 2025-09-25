*** Settings ***
Resource   ../CustomerPageResources/CustomerPage.resource


*** Keywords ***
Get Simple Name
    [Documentation]    Get simple name from table row, handling possible variations in structure
    ${target}    Set Variable    ${name_fallback_selector % ${r}}
    ${has}       Run Keyword And Return Status    Page Should Contain Element    ${target}
    IF    ${has}
        ${name}    Get Text    ${target}
    ELSE
        ${raw}      Get Text    ${name_selector % ${r}}
        ${lines}    Split To Lines    ${raw}
        ${name}     Get From List    ${lines}    -1
    END
    RETURN    ${name}

Get Table Row Data
    [Documentation]    Log table data for each row (Name, Last seen, Orders, etc.)
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}

    ${row_count}    Get Element Count    ${table_row}
    ${end}          Evaluate    ${row_count} + 1

    FOR    ${r}    IN RANGE    1    ${end}
        ${name}              Get Simple Name    ${r}
        ${last_seen}         Get Text    ${last_seen_selector % ${r}}
        ${orders}            Get Text    ${orders_selector % ${r}}
        ${total_spent}       Get Text    ${total_spent_selector % ${r}}
        ${latest_purchase}   Get Text    ${latest_purchase_selector % ${r}}

        ${has_news}    Run Keyword And Return Status    Page Should Contain Element    ${news_selector % ${r}}
        IF    ${has_news}
            ${news}    Get Element Attribute    ${news_selector % ${r}}    aria-label
        ELSE
            ${news}    Set Variable    No
        END

        @{chips}      Get WebElements    ${segment_selector % ${r}}
        ${segments}   Create List
        FOR    ${chip}    IN    @{chips}
            ${txt}    Get Text    ${chip}
            Append To List    ${segments}    ${txt}
        END
        ${segment}    Catenate    SEPARATOR=,     @{segments}

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
