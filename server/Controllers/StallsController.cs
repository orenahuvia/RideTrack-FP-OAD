using Microsoft.AspNetCore.Mvc;
using RideTrack_FP_OAD.BL;

namespace RideTrack_FP_OAD.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StallsController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            try
            {
                List<Stalls> stalls = Stalls.GetAllStalls();
                return Ok(stalls);
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
                List<Stalls> stalls = Stalls.GetStallsByPayerName(payerName);

                if (stalls.Count == 0)
                {
                    return NotFound($"No stalls found for payer: {payerName}");
                }

                return Ok(stalls);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost]
        public IActionResult Post([FromBody] Stalls stall)
        {
            try
            {
                int res = Stalls.AddStall(stall);
                return Ok(res);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut]
        public IActionResult Put([FromBody] Stalls stall)
        {
            try
            {
                if (stall == null)
                {
                    return BadRequest("Stall data is required.");
                }

                int rowsAffected = Stalls.UpdateStall(stall);

                if (rowsAffected > 0)
                {
                    return Ok(new
                    {
                        RowsAffected = rowsAffected,
                        Message = "Stall updated successfully",
                        Stall = new
                        {
                            stall.StallId,
                            stall.CompetitionId,
                            stall.HorseId,
                            stall.PayerId,
                            stall.StallNumber,
                            stall.ArrivalDate,
                            stall.DepartureDate,
                            stall.DailyRate,
                            stall.TotalPrice
                        }
                    });
                }
                else
                {
                    return NotFound("Stall not found or no changes were made.");
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
                int rowsAffected = Stalls.DeleteStall(id);

                if (rowsAffected > 0)
                {
                    return Ok(new
                    {
                        RowsAffected = rowsAffected,
                        Message = "Stall deleted successfully",
                        DeletedStallId = id
                    });
                }
                else
                {
                    return NotFound($"Stall with ID {id} not found.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

    }
}
