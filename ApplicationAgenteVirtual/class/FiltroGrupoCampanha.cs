using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApplicationAgenteVirtual
{
    public class FiltroGrupoCampanha
    {
        public int? IDFiltroGrupoCampanha { get; set; }

        public int IDTipoFiltro { get; set; }

        public string Operador { get; set; }

        public string Valor { get; set; }

        public string Condicao { get; set; }
    }
}