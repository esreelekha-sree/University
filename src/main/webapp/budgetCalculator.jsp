<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Require finance session (same as before) - if not logged in, redirect to login
    String fEmail = (String) session.getAttribute("financeEmail");
    if (fEmail == null) {
        response.sendRedirect(request.getContextPath() + "/financeLogin.jsp");
        return;
    }
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Budget Calculator</title>
  <style>
    :root{
      --page-bg:#e9f6ff;
      --card-bg: linear-gradient(180deg,#0d6efd,#0a58ca);
      --accent:#0d6efd;
      --muted:#6b7280;
      --danger:#d9534f;
      --card-text:#fff;
      --radius:12px;
      --container:1100px;
      --shadow: 0 10px 30px rgba(11,78,135,0.06);
    }
    html,body{margin:0;font-family:Inter,Segoe UI,Arial;background:var(--page-bg);color:#0f172a}
    .wrap{max-width:var(--container);margin:28px auto;padding:20px}
    .header{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
    h1{margin:0;font-size:26px}
    .card { background:#fff;border-radius:12px; padding:18px; box-shadow:var(--shadow) }
    .btn { background:var(--accent); color:#fff; border:none; padding:8px 12px; border-radius:8px; cursor:pointer; font-weight:700; text-decoration:none; display:inline-block }
    .btn-danger { background:var(--danger); color:#fff; }
    table{width:100%; border-collapse:collapse; margin-top:12px}
    th,td{padding:8px;border:1px solid #e6eefc; text-align:left; vertical-align:middle}
    th {background: #f1f8ff; color:#0b4fa6}
    input[type="text"], input[type="number"]{width:100%;padding:6px;border:1px solid #dfe8fb;border-radius:6px;box-sizing:border-box}
    .muted{color:var(--muted)}
    .flex {display:flex; gap:12px; align-items:center}
    .small {font-size:13px;color:var(--muted)}
    .summary {display:grid; grid-template-columns: repeat(3, 1fr); gap:12px; margin-top:14px}
    .summary .box { background: linear-gradient(180deg,#ffffff,#f4f8ff); padding:12px; border-radius:10px; border:1px solid #e6eefc}
    .right { text-align:right; }
    .dept-split { display:flex; gap:8px; flex-wrap:wrap; margin-top:8px; }
    .dept-split input { width:80px; }
    .actions { margin-top:12px; display:flex; gap:8px; flex-wrap:wrap; }
    @media(max-width:900px){ .summary { grid-template-columns: 1fr } .flex{flex-direction:column;align-items:flex-start} }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div>
        <h1>Budget Calculator</h1>
        <div class="small muted">Quickly estimate budgets, tax, contingency and department splits</div>
      </div>
      <div>
        Signed in: <strong><%= fEmail %></strong>
        &nbsp;&nbsp;
        <a class="btn btn-danger" href="<%= request.getContextPath() %>/financeLogout.jsp">Logout</a>
        <a class="back-btn" href="<%=request.getContextPath()%>/financePortal.jsp">Back to Portal</a>
      </div>
    </div>

    <div class="card">
      <!-- Top inputs: available budget, default tax and default contingency -->
      <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;flex-wrap:wrap">
        <div style="flex:1;min-width:280px">
          <label class="small">Available Budget (total)</label>
          <input type="number" id="availableBudget" value="" placeholder="Enter available budget (₹)" />
        </div>

        <div style="flex:1;min-width:260px">
          <label class="small">Default Tax / GST %</label>
          <input type="number" id="defaultTax" value="0" step="0.01" />
        </div>

        <div style="flex:1;min-width:260px">
          <label class="small">Default Contingency %</label>
          <input type="number" id="defaultCont" value="5" step="0.01" />
        </div>
      </div>

      <!-- Itemized table -->
      <table id="itemsTable" aria-describedby="itemsDescription">
        <caption id="itemsDescription" style="caption-side:top;text-align:left;padding:8px 0;color:var(--muted)">Itemized budget lines — add rows, enter qty & unit cost, tax and contingency applied per-item or use defaults.</caption>
        <thead>
          <tr>
            <th style="width:36px">#</th>
            <th>Item description</th>
            <th style="width:110px">Qty</th>
            <th style="width:140px">Unit cost (₹)</th>
            <th style="width:100px">Tax %</th>
            <th style="width:120px">Contingency %</th>
            <th style="width:140px">Line total (₹)</th>
            <th style="width:90px">Dept</th>
            <th style="width:36px"></th>
          </tr>
        </thead>
        <tbody id="itemsBody">
          <!-- rows created dynamically by JavaScript -->
        </tbody>
      </table>

      <!-- action buttons -->
      <div class="actions">
        <button class="btn" onclick="addRow()">+ Add row</button>
        <button class="btn" onclick="recalculate()">Recalculate</button>
        <button class="btn" onclick="autoFillTaxCont()">Apply defaults</button>
        <button class="btn" onclick="exportCSV()">Export CSV</button>
        <button class="btn btn-danger" onclick="clearAll()">Clear</button>
      </div>

      <!-- summary boxes -->
      <div class="summary" aria-live="polite" style="margin-top:14px">
        <div class="box">
          <div class="small">Subtotal (items)</div>
          <div id="subtotal" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>
        <div class="box">
          <div class="small">Total Tax</div>
          <div id="totaltax" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>
        <div class="box">
          <div class="small">Contingency</div>
          <div id="totalcont" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>

        <div class="box">
          <div class="small">Grand Total</div>
          <div id="grandtotal" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>
        <div class="box">
          <div class="small">Available Budget</div>
          <div id="availShow" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>
        <div class="box">
          <div class="small">Remaining / (Over)</div>
          <div id="remaining" style="font-weight:800;font-size:18px">₹ 0.00</div>
        </div>
      </div>

      <!-- department split inputs -->
      <div style="margin-top:12px">
        <label class="small">Department split (enter % for each department — totals should sum to 100%)</label>
        <div class="dept-split" id="deptSplit">
          <input type="text" placeholder="Dept (e.g. CSE)" id="dept0" value="CSE" />
          <input type="number" placeholder="% (e.g. 50)" id="pct0" value="50" />
          <input type="text" placeholder="Dept" id="dept1" value="ECE" />
          <input type="number" placeholder="%" id="pct1" value="50" />
          <!-- add more pairs by editing DOM if needed -->
        </div>
        <div style="margin-top:8px">
          <button class="btn" onclick="applyDeptSplit()">Apply Split</button>
        </div>
      </div>

      <!-- where the computed allocations are shown -->
      <div style="margin-top:14px" id="deptAllocations" aria-live="polite"></div>

    </div>
  </div>

<script>
  /************************************************************************
   * Budget calculator script
   * - rowCount: simple incremental id for rows
   * - addRow(data): creates a new table row. 'data' is optional object
   * - recalculate(): recalculates subtotal, tax, contingency, totals, remaining
   * - autoFillTaxCont(): fills tax & contingency fields from defaults
   * - applyDeptSplit(): allocate grand total across provided department percentages
   * - exportCSV(): produce a vertical CSV - one item per line (header + rows)
   * - clearAll(): reset rows
   *
   * Comments added to help beginners understand each function.
   ************************************************************************/

  // keep track of how many rows have been added
  let rowCount = 0;

  // helper to format money consistently (two decimals)
  function money(x){ return Number(x||0).toFixed(2); }

  // Add a new row to the items table.
  // 'data' can contain: desc, qty, unit, tax, cont, dept
  function addRow(data) {
    rowCount++;
    const tbody = document.getElementById('itemsBody');
    const tr = document.createElement('tr');
    tr.id = 'row_' + rowCount;

    // row markup - each input has a class we use later to read values
    tr.innerHTML = `
      <td>${rowCount}</td>
      <td><input type="text" class="desc" placeholder="Description" value="${data?.desc||''}" /></td>
      <td><input type="number" min="0" step="1" class="qty" value="${data?.qty||1}" /></td>
      <td><input type="number" min="0" step="0.01" class="unit" value="${data?.unit||0}" /></td>
      <td><input type="number" min="0" step="0.01" class="tax" value="${data?.tax||document.getElementById('defaultTax').value||0}" /></td>
      <td><input type="number" min="0" step="0.01" class="cont" value="${data?.cont||document.getElementById('defaultCont').value||0}" /></td>
      <td class="right lineTotal">₹ ${money(0)}</td>
      <td><input type="text" class="dept" value="${data?.dept||''}" placeholder="Dept"/></td>
      <td class="right"><button class="btn btn-danger" onclick="removeRow('${tr.id}');return false;">Del</button></td>
    `;
    tbody.appendChild(tr);

    // listen for change on qty/unit/tax/cont to auto-recalculate
    ['qty','unit','tax','cont'].forEach(cls => {
      tr.querySelector('.' + cls).addEventListener('input', recalculate);
    });

    // run an initial recalc to update totals
    recalculate();
  }

  // Remove a row by its id (e.g., 'row_2') and reindex the displayed row numbers
  function removeRow(id) {
    const r = document.getElementById(id);
    if (!r) return;
    r.remove();
    // re-index display numbers (1..n)
    const rows = document.querySelectorAll('#itemsBody tr');
    let i=1; rows.forEach(row => { row.querySelector('td:first-child').innerText = i++; });
    recalculate();
  }

  // Recalculate subtotal, tax, contingency, grand total, and remaining budget.
  // - Reads each row's qty, unit, tax%, cont% to compute line totals.
  // - Updates the summary boxes (subtotal, totaltax, totalcont, grandtotal).
  function recalculate() {
    const rows = document.querySelectorAll('#itemsBody tr');
    let subtotal=0, totaltax=0, totalcont=0;

    rows.forEach(row => {
      const qty = Number(row.querySelector('.qty').value || 0);
      const unit = Number(row.querySelector('.unit').value || 0);
      const tax = Number(row.querySelector('.tax').value || 0);
      const cont = Number(row.querySelector('.cont').value || 0);

      // base cost = qty * unit
      const base = qty * unit;

      // amounts
      const taxAmt = base * (tax/100);
      const contAmt = base * (cont/100);

      // line total includes base + tax + contingency
      const lineTotal = base + taxAmt + contAmt;

      // update the line total in the table
      row.querySelector('.lineTotal').innerText = '₹ ' + money(lineTotal);

      // accumulate sums
      subtotal += base;
      totaltax += taxAmt;
      totalcont += contAmt;
    });

    // grand total = subtotal + tax + contingency
    const grand = subtotal + totaltax + totalcont;

    // update UI with formatted numbers
    document.getElementById('subtotal').innerText = '₹ ' + money(subtotal);
    document.getElementById('totaltax').innerText = '₹ ' + money(totaltax);
    document.getElementById('totalcont').innerText = '₹ ' + money(totalcont);
    document.getElementById('grandtotal').innerText = '₹ ' + money(grand);

    // show available budget and remaining amount
    const avail = Number(document.getElementById('availableBudget').value || 0);
    document.getElementById('availShow').innerText = '₹ ' + money(avail);
    const rem = avail - grand;
    const remEl = document.getElementById('remaining');
    remEl.innerText = (rem < 0 ? '-₹ ' + money(Math.abs(rem)) : '₹ ' + money(rem));
    remEl.style.color = rem < 0 ? 'var(--danger)' : 'inherit';

    // if department split has already been applied, keep it in sync
    if (document.getElementById('_deptApplied')) applyDeptSplit();
  }

  // Fill each row's tax and contingency inputs using the default inputs
  function autoFillTaxCont() {
    const t = Number(document.getElementById('defaultTax').value || 0);
    const c = Number(document.getElementById('defaultCont').value || 0);
    document.querySelectorAll('#itemsBody tr').forEach(row => {
      row.querySelector('.tax').value = t;
      row.querySelector('.cont').value = c;
    });
    recalculate();
  }

  // Apply department split: read dept/pct pairs, validate and compute each department's share.
  // - If percentages don't sum to 100, a warning is shown and allocations are made proportionally.
  function applyDeptSplit() {
    const allocations = [];
    const deptInputs = Array.from(document.querySelectorAll('#deptSplit input'));
    // expecting pairs [dept,pct,dept,pct,...]
    for (let i=0;i<deptInputs.length;i+=2){
      const dept = deptInputs[i]?.value?.trim();
      const pct = Number(deptInputs[i+1]?.value || 0);
      if (dept) allocations.push({ dept, pct });
    }

    // sum of percentages provided
    const totalPct = allocations.reduce((s,a)=>s+(a.pct||0),0);

    // read grand total (remove currency chars)
    const grand = parseFloat(document.getElementById('grandtotal').innerText.replace(/[₹, ]/g,'')) || 0;
    const container = document.getElementById('deptAllocations');
    container.innerHTML = '';
    const note = document.createElement('div');
    note.className = 'small muted';

    if (Math.abs(totalPct - 100) > 0.01) {
      // show warning but still allocate proportionally
      note.innerText = 'Warning: department percentages do not total 100% (current: ' + money(totalPct) + '%). Allocation will be proportional to provided percentages.';
      container.appendChild(note);
    } else {
      note.innerText = 'Department allocation (100%):';
      container.appendChild(note);
    }

    // compute allocations for each dept
    allocations.forEach(a=>{
      const share = (totalPct === 0) ? 0 : (a.pct/ (totalPct||1)) * grand;
      const box = document.createElement('div');
      box.style.marginTop = '8px';
      box.innerHTML = `<strong>${a.dept}</strong>: ₹ ${money(share)} (${money((share/grand||0)*100)}%)`;
      container.appendChild(box);
    });

    // mark applied - this hidden input is used to know to keep the split updated when totals change
    let flag = document.getElementById('_deptApplied');
    if (!flag) {
      flag = document.createElement('input'); flag.type='hidden'; flag.id='_deptApplied';
      container.appendChild(flag);
    }
    flag.value = '1';
  }

  // Export CSV - generates a CSV where each item is in a separate line (vertical).
  // Header row first, then one row per item.
  function exportCSV() {
    const rows = Array.from(document.querySelectorAll('#itemsBody tr'));
    const lines = [];

    // Header row
    lines.push(['#','description','qty','unit','tax%','cont%','lineTotal','dept'].join(','));

    // One CSV line per table row (vertical list)
    rows.forEach((r, idx) => {
      const desc = r.querySelector('.desc').value.replace(/,/g, ' ');
      const qty = r.querySelector('.qty').value;
      const unit = r.querySelector('.unit').value;
      const tax = r.querySelector('.tax').value;
      const cont = r.querySelector('.cont').value;
      const line = r.querySelector('.lineTotal').innerText.replace(/[₹, ]/g, '');
      const dept = r.querySelector('.dept').value;

      lines.push([
        idx + 1,
        desc,
        qty,
        unit,
        tax,
        cont,
        line,
        dept
      ].join(','));
    });

    // Join with newline for vertical CSV
    const csv = lines.join("\n");

    // Create a downloadable blob and trigger the download
    const blob = new Blob([csv], {type: 'text/csv'});
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'budget_estimate.csv';
    document.body.appendChild(a);
    a.click();

    // cleanup
    setTimeout(() => {
      URL.revokeObjectURL(url);
      a.remove();
    }, 1000);
  }

  // Clear all rows and reset counters
  function clearAll() {
    if (!confirm('Clear all rows and reset calculator?')) return;
    document.getElementById('itemsBody').innerHTML = '';
    rowCount = 0;
    recalculate();
  }

  // Pre-populate two helpful rows on load (same sample data as you had before)
  window.addEventListener('load', function(){
    addRow({desc:'Projector (rental)', qty:1, unit:5000, tax:18, cont:5, dept:'CSE'});
    addRow({desc:'Stationery & Printing', qty:1, unit:2000, tax:0, cont:5, dept:'Admin'});
    recalculate();
  });
</script>
</body>
</html>
