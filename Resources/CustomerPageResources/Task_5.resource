*** Settings ***
Resource   ../CustomerPageResources/CustomerPage.resource


*** Keywords ***
Get Expense Report
    [Documentation]    Analyze user spending (single page), print spenders, sum total, validate threshold.
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}

    ${rows}              Get Element Count    ${table_row}
    ${total}             Set Variable    0.0
    ${counter}           Set Variable    1

    FOR    ${r}    IN RANGE    1    ${rows + 1}
        ${name}          Get Simple Name    ${r}
        ${amount_txt}    Get Text    ${total_spent_selector % ${r}}
        ${clean_txt}     Replace String    ${amount_txt}    $    ${EMPTY}
        ${clean_txt}     Replace String    ${clean_txt}    ,    ${EMPTY}
        ${clean_txt}     Strip String      ${clean_txt}
        ${amount}        Run Keyword If    '${clean_txt}' == ''    Set Variable    0    ELSE    Convert To Number    ${clean_txt}

        IF    ${amount} > 0
            Log To Console    ${counter}. ${name}: ${amount_txt}
            ${counter}       Evaluate    ${counter} + 1
        END

        ${total}          Evaluate    float(${total}) + float(${amount})
    END

    ${total_fmt}      Evaluate    "$" + format(float(${total}), ",.2f")
    Log To Console     =========================
    Log To Console     Total Customer Spending: ${total_fmt}
    Log To Console     =========================

    ${threshold}      Set Variable    3500
    ${meets}          Evaluate    float(${total}) >= ${threshold}
    ${thresh_fmt}     Evaluate    "$" + format(float(${threshold}), ",.0f")

    IF    ${meets}
        Log To Console    PASS: Total Spending (${total_fmt}) meets minimum threshold (${thresh_fmt})
    ELSE
        Log To Console    FAIL: Total Spending (${total_fmt}) is below minimum (${thresh_fmt})
        Fail    Total Spending (${total_fmt}) is below minimum (${thresh_fmt})
    END
