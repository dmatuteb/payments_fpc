DECLARE
  xml_data XMLType := XMLType(
    '<payments_processes>
      <process>
        <process_id>1</process_id>
        <payments>
          <payment><account>6</account><amount>30</amount></payment>
        </payments>
      </process>
      <process>
        <process_id>2</process_id>
        <payments>
          <payment><account>1</account><amount>10</amount></payment>
          <payment><account>2</account><amount>20</amount></payment>
        </payments>
      </process>
    </payments_processes>'
  );

  process_id NUMBER;
  account NUMBER;
  amount NUMBER;
BEGIN
  FOR r IN (
    SELECT
      xt.process_id,
      xtp.account,
      xtp.amount
    FROM
      XMLTable(
        '/payments_processes/process'
        PASSING xml_data
        COLUMNS
          process_id NUMBER PATH 'process_id',
          payments XMLType PATH 'payments'
      ) xt,
      XMLTable(
        '/payments/payment'
        PASSING xt.payments
        COLUMNS
          account NUMBER PATH 'account',
          amount NUMBER PATH 'amount'
      ) xtp
  )
  LOOP
    process_id := r.process_id;
    account := r.account;
    amount := r.amount;

    -- Process the extracted data as needed
    -- For example, you can print it
    DBMS_OUTPUT.PUT_LINE('Process ID: ' || process_id || ', Account: ' || account || ', Amount: ' || amount);
  END LOOP;
END;
