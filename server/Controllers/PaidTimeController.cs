using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RideTrack_FP_OAD.BL;

namespace RideTrack_FP_OAD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaidTimeController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            try
            {
                List<PaidTimes> paidtimes = PaidTimes.GetAllPaidTimes();
                return Ok(paidtimes);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("bypayer/{payerName}")]
        public IActionResult GetByPayerName(string payerName)
        {
            try
            {
                List<PaidTimes> paidTimes = PaidTimes.GetPaidTimesByPayerName(payerName);

                if (paidTimes.Count == 0)
                {
                    return NotFound($"No paid times found for payer: {payerName}");
                }

                return Ok(paidTimes);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpPost]
        public IActionResult Post([FromBody] PaidTimes paidtimes)
        {
            try
            {
                int res = PaidTimes.AddPaidTime(paidtimes);
                return Ok(res);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut]
        public IActionResult Put([FromBody] PaidTimes paidTime)
        {
            try
            {
                if (paidTime == null)
                {
                    return BadRequest("PaidTime data is required");
                }

                int rowsAffected = PaidTimes.UpdatePaidTime(paidTime);

                if (rowsAffected > 0)
                {
                    return Ok(new
                    {
                        RowsAffected = rowsAffected,
                        Message = "PaidTime updated successfully",
                        PaidTime = new
                        {
                            paidTime.PaidTimeId,
                            paidTime.CompetitionId,
                            paidTime.RiderId,
                            paidTime.HorseId,
                            paidTime.PayerId,
                            paidTime.ArenaName,
                            paidTime.Day,
                            paidTime.SlotType,
                            paidTime.Price
                        }
                    });
                }
                else
                {
                    return NotFound("PaidTime not found or no changes were made");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                int rowsAffected = PaidTimes.DeletePaidTime(id);

                if (rowsAffected > 0)
                {
                    return Ok(new
                    {
                        RowsAffected = rowsAffected,
                        Message = $"PaidTime with ID {id} deleted successfully",
                        DeletedPaidTimeId = id
                    });
                }
                else
                {
                    return NotFound($"PaidTime with ID {id} not found");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


    }
}

