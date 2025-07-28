codeunit 77150 "ReturnFlows Event Sub PTE"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Refund Process Events", OnAfterProcessSalesDocument, '', false, false)]
    local procedure OnAfterProcessSalesDocumentCheckReturnFlows(RefundHeader: Record "Shpfy Refund Header"; var SalesHeader: Record "Sales Header")
    var
        ReturnFlowsRefunds: Codeunit "ReturnFlows Refunds PTE";
    begin
        if RefundHeader."Total Refunded Amount" <> 0 then
            exit;

        ReturnFlowsRefunds.CheckReturnFlowsRefund(RefundHeader, SalesHeader);
    end;
}